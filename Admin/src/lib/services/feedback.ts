import { getAdminDb } from "../firebase/server";
import { COLLECTIONS } from "../firebase/constants";

export async function getFeedbackCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.REVIEWS).count().get();
  return snapshot.data().count;
}

export async function getReviewsSnapshot(limitCount: number = 10) {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(COLLECTIONS.REVIEWS)
    .orderBy("createdAt", "desc")
    .limit(limitCount)
    .get();
  return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

export async function getReviewsCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.REVIEWS).count().get();
  return snapshot.data().count;
}
