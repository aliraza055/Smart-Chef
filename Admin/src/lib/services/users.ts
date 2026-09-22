import { getAuth } from "firebase-admin/auth";
import { getAdminDb } from "../firebase/server";
import { COLLECTIONS } from "../firebase/constants";

export async function getUsersCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.USERS).count().get();
  return snapshot.data().count;
}

export async function getTotalRecipes(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.RECIPES).count().get();
  return snapshot.data().count;
}

export async function getReviewsCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.REVIEWS).count().get();
  return snapshot.data().count;
}

export async function getRecentRecipes(limitCount: number = 10) {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(COLLECTIONS.RECIPES)
    .orderBy("createdAt", "desc")
    .limit(limitCount)
    .get();
  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

export async function getUserGrowthData(days: number = 30) {
  const adminDb = getAdminDb();
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - days);

  const snapshot = await adminDb
    .collection(COLLECTIONS.USERS)
    .where("createdAt", ">=", thirtyDaysAgo)
    .orderBy("createdAt", "asc")
    .get();

  const dailyCounts: Record<string, number> = {};
  snapshot.docs.forEach((doc) => {
    const data = doc.data();
    const createdAt = data.createdAt;
    if (createdAt) {
      const dateStr = createdAt.toDate
        ? createdAt.toDate().toISOString().split("T")[0]
        : createdAt;
      dailyCounts[dateStr] = (dailyCounts[dateStr] || 0) + 1;
    }
  });

  const result = [];
  for (let i = days - 1; i >= 0; i--) {
    const date = new Date();
    date.setDate(date.getDate() - i);
    const dateStr = date.toISOString().split("T")[0];
    result.push({ date: dateStr, users: dailyCounts[dateStr] || 0 });
  }

  return result;
}

export async function getNewUsersLast7Days(): Promise<number> {
  const adminDb = getAdminDb();
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

  const snapshot = await adminDb
    .collection(COLLECTIONS.USERS)
    .where("createdAt", ">=", sevenDaysAgo)
    .get();

  return snapshot.size;
}

export async function getUsersSnapshot() {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(COLLECTIONS.USERS)
    .orderBy("createdAt", "desc")
    .limit(20)
    .get();
  return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

export async function getAllUsersSnapshot() {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(COLLECTIONS.USERS)
    .orderBy("createdAt", "desc")
    .get();

  return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

export async function updateUserRestriction(userId: string, restricted: boolean) {
  const adminDb = getAdminDb();
  const userRef = adminDb.collection(COLLECTIONS.USERS).doc(userId);
  const currentDoc = await userRef.get();
  const currentData = currentDoc.data() || {};
  const nextStatus = restricted ? "restricted" : "active";

  await Promise.all([
    userRef.set(
      {
        ...currentData,
        isRestricted: restricted,
        accountStatus: nextStatus,
        updatedAt: new Date(),
      },
      { merge: true },
    ),
    getAuth().updateUser(userId, { disabled: restricted }),
  ]);

  return { id: userId, isRestricted: restricted, accountStatus: nextStatus };
}

export async function deleteUserAccount(userId: string) {
  const adminDb = getAdminDb();

  try {
    await getAuth().deleteUser(userId);
  } catch (error) {
    const message = error instanceof Error ? error.message : "";
    if (!message.includes("auth/user-not-found")) {
      throw error;
    }
  }

  await adminDb.collection(COLLECTIONS.USERS).doc(userId).delete();
  return { id: userId, deleted: true };
}

export async function getRecipesSnapshot() {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(COLLECTIONS.RECIPES)
    .orderBy("createdAt", "desc")
    .limit(10)
    .get();
  return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}
