import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { getUsersCount, getTotalRecipes, getReviewsCount, getRecentRecipes, getUserGrowthData, getNewUsersLast7Days } from "@/lib/services/users";
import { getRecipeStats } from "@/lib/services/recipes";
import { getFeedbackCount } from "@/lib/services/feedback";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const [usersCount, recipesCount, reviewsCount, recentRecipes, growthData, newUsers7Days, recipeStats] = await Promise.all([
      getUsersCount(),
      getTotalRecipes(),
      getReviewsCount(),
      getRecentRecipes(10),
      getUserGrowthData(30),
      getNewUsersLast7Days(),
      getRecipeStats(),
    ]);

    const feedbackCount = await getFeedbackCount();

    return NextResponse.json({
      source: {
        projectId: process.env.FIREBASE_PROJECT_ID || "smart-chef-ef910",
        collections: {
          users: "Users",
          recipes: "Receipes",
          reviews: "Reviews",
        },
      },
      stats: {
        totalUsers: usersCount,
        totalRecipes: recipesCount,
        totalReviews: reviewsCount,
        feedback: feedbackCount,
        newUsers: newUsers7Days,
        reportedContent: { status: "unavailable", reason: "No report collection or report status field exists in the current Firestore schema." },
        activeUsers: { status: "unavailable", reason: "No active-users metric exists in the current Firestore schema." },
      },
      recentRecipes,
      recipeStats,
      userGrowthData: growthData,
    });
  } catch (error) {
    console.error("Dashboard data fetch error:", error);
    const message = error instanceof Error ? error.message : "Unable to load dashboard data";
    return NextResponse.json(
      {
        error: "Firebase Admin access failed.",
        details: message,
        hint: "Set FIREBASE_SERVICE_ACCOUNT in Admin/.env.local or configure GOOGLE_APPLICATION_CREDENTIALS to a valid service-account JSON file for project smart-chef-ef910.",
      },
      { status: 500 }
    );
  }
}
