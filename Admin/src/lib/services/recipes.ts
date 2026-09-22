import { getAdminDb } from "../firebase/server";
import { COLLECTIONS } from "../firebase/constants";

export async function getRecipeStats() {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.RECIPES).get();
  let total = 0;
  let published = 0;
  let hidden = 0;
  let reported = 0;

  snapshot.docs.forEach((doc) => {
    total++;
    const data = doc.data();
    const status = data.status;
    if (
      status === "active" ||
      status === "published" ||
      status === "Active" ||
      status === "Published"
    ) {
      published++;
    } else if (status === "hidden" || status === "Hidden") {
      hidden++;
    } else if (status === "reported" || status === "Reported") {
      reported++;
    }
  });

  return { total, published, hidden, reported };
}

export async function getRecipeCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.RECIPES).count().get();
  return snapshot.data().count;
}
