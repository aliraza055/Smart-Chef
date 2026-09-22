import { getAdminDb } from "../firebase/server";
import { COLLECTIONS } from "../firebase/constants";

export async function getReportedContentCount(): Promise<number> {
  const adminDb = getAdminDb();

  const [reportedRecipes, reportedReviews] = await Promise.all([
    adminDb
      .collection(COLLECTIONS.RECIPES)
      .where("status", "==", "reported")
      .get(),
    adminDb
      .collection("Reviews")
      .where("isReported", "==", true)
      .get(),
  ]);

  return reportedRecipes.size + reportedReviews.size;
}

export async function getReportsSnapshot() {
  const adminDb = getAdminDb();

  const [reportedRecipes, reportedReviews] = await Promise.all([
    adminDb
      .collection(COLLECTIONS.RECIPES)
      .where("status", "==", "reported")
      .orderBy("updatedAt", "desc")
      .get(),
    adminDb
      .collection("Reviews")
      .where("isReported", "==", true)
      .orderBy("createdAt", "desc")
      .get(),
  ]);

  const recipes = reportedRecipes.docs.map((doc) => ({
    id: doc.id,
    itemId: doc.id,
    type: "recipe",
    title: doc.data().name || doc.data().title || "Unnamed recipe",
    author: doc.data().author || doc.data().userName || "Unknown",
    reason: doc.data().reportReason || "Flagged by a user",
    status: doc.data().status || "reported",
    createdAt: doc.data().updatedAt || doc.data().createdAt,
  }));

  const reviews = reportedReviews.docs.map((doc) => ({
    id: doc.id,
    itemId: doc.id,
    type: "review",
    title: `Review for ${doc.data().recipeId || "recipe"}`,
    author: doc.data().userName || "Unknown user",
    reason: doc.data().reportReason || "Inappropriate review",
    status: doc.data().status || "reported",
    createdAt: doc.data().createdAt,
  }));

  return [...recipes, ...reviews].sort((a, b) => {
    const aTime = a.createdAt?.toDate ? a.createdAt.toDate().getTime() : new Date(a.createdAt || 0).getTime();
    const bTime = b.createdAt?.toDate ? b.createdAt.toDate().getTime() : new Date(b.createdAt || 0).getTime();
    return bTime - aTime;
  });
}

export async function markReportResolved(itemId: string, type: "recipe" | "review") {
  const adminDb = getAdminDb();

  if (type === "recipe") {
    const ref = adminDb.collection(COLLECTIONS.RECIPES).doc(itemId);
    const current = await ref.get();
    const data = current.data() || {};

    await ref.set(
      {
        ...data,
        status: "hidden",
        reportResolvedAt: new Date(),
        reportReason: "Resolved by admin",
      },
      { merge: true },
    );

    return { id: itemId, type, resolved: true };
  }

  const ref = adminDb.collection("Reviews").doc(itemId);
  const current = await ref.get();
  const data = current.data() || {};

  await ref.set(
    {
      ...data,
      isReported: false,
      status: "reviewed",
      reportResolvedAt: new Date(),
    },
    { merge: true },
  );

  return { id: itemId, type, resolved: true };
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

export async function getActiveUsersCount(): Promise<number> {
  throw new Error("Active users metric is not implemented in the current SmartChef Firestore schema.");
}

export async function getTotalUsersCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.USERS).count().get();
  return snapshot.data().count;
}
