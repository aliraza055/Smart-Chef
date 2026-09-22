import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { getFeedbackCount } from "@/lib/services/feedback";
import { getRecipeStats } from "@/lib/services/recipes";
import { getReportedContentCount } from "@/lib/services/reports";
import { getNewUsersLast7Days, getTotalRecipes, getUserGrowthData, getUsersCount, getReviewsCount } from "@/lib/services/users";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const [totalUsers, totalRecipes, totalReviews, newUsers, recipeStats, reportedContent, feedbackCount, userGrowthData] = await Promise.all([
      getUsersCount(),
      getTotalRecipes(),
      getReviewsCount(),
      getNewUsersLast7Days(),
      getRecipeStats(),
      getReportedContentCount(),
      getFeedbackCount(),
      getUserGrowthData(30),
    ]);

    return NextResponse.json({
      metrics: {
        totalUsers,
        totalRecipes,
        totalReviews,
        newUsers,
        reportedContent,
        feedbackCount,
      },
      recipeStats,
      userGrowthData,
    });
  } catch (error) {
    console.error("Analytics fetch error:", error);
    return NextResponse.json({ error: "Unable to load analytics" }, { status: 500 });
  }
}
