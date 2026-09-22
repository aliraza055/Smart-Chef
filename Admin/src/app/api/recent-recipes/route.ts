import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { getRecentRecipes } from "@/lib/services/users";
import { getRecipeStats } from "@/lib/services/recipes";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const [recipes, stats] = await Promise.all([
      getRecentRecipes(10),
      getRecipeStats(),
    ]);
    return NextResponse.json({ recipes, stats });
  } catch (error) {
    console.error("Recipes fetch error:", error);
    return NextResponse.json(
      { error: "Unable to load recipes" },
      { status: 500 }
    );
  }
}
