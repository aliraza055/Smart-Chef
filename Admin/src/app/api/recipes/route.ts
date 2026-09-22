import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { deleteRecipe, getAllRecipesSnapshot, getRecipeStats, updateRecipeStatus } from "@/lib/services/recipes";

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
      getAllRecipesSnapshot(),
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

export async function POST(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const { action, recipeId, status } = await req.json();

    if (!recipeId || !action) {
      return NextResponse.json({ error: "Missing recipeId or action" }, { status: 400 });
    }

    if (action === "toggleStatus") {
      const result = await updateRecipeStatus(recipeId, status || "active");
      return NextResponse.json({ success: true, recipe: result });
    }

    if (action === "deleteRecipe") {
      const result = await deleteRecipe(recipeId);
      return NextResponse.json({ success: true, recipe: result });
    }

    return NextResponse.json({ error: "Unsupported action" }, { status: 400 });
  } catch (error) {
    console.error("Recipe action error:", error);
    return NextResponse.json(
      { error: "Recipe action failed" },
      { status: 500 }
    );
  }
}
