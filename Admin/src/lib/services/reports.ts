import { getAdminDb } from "../firebase/server";
import { COLLECTIONS } from "../firebase/constants";

export async function getReportedContentCount(): Promise<number> {
  throw new Error("Reported content is not implemented in the current SmartChef Firestore schema.");
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
