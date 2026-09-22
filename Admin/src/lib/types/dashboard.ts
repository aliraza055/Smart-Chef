export type Trend = "up" | "down";

export interface StatCardData {
  label: string;
  value: string | number;
  change?: string;
  trend?: Trend;
  desc?: string;
}

export interface UserGrowthPoint {
  date: string;
  users: number;
}

export interface ActivityItem {
  id: string;
  type: string;
  description: string;
  target?: string;
  time: string;
}

export type RecipeStatusType = "Active" | "Hidden" | "Reported";

export interface RecipeItem {
  id: string;
  name: string;
  author: string;
  category: string;
  image: string;
  createdAt: Date | string;
  status?: string;
  likes?: number;
  avgRating?: number;
}

export interface RecipeStatsData {
  total: number;
  published: number;
  hidden: number;
  reported: number;
}

export interface DashboardData {
  stats: StatCardData[];
  userGrowthData: UserGrowthPoint[];
  recentRecipes: RecipeItem[];
  recipeStats: RecipeStatsData;
}
