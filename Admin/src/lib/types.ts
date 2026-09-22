export type User = {
  id: string;
  name: string;
  gmail?: string;
  imageUrl: string;
  totalRecipes: number;
  totalFavorites: number;
  bio: string;
  followers: number;
  following: number;
  level: string;
  streakDays: number;
  favoriteRecipeIds: string[];
  createdAt: Date | string;
};

export type Recipe = {
  id: string;
  docId: string;
  name: string;
  description: string;
  image: string;
  category: string;
  ingredients: string[];
  steps: string[];
  userName?: string;
  userPhoto?: string;
  difficulty: string;
  time: number;
  userUId: string;
  avgRating: number;
  totalReviews: number;
  likes: number;
  createdAt: Date | string;
};

export type Review = {
  id: string;
  recipeId: string;
  userId: string;
  userName: string;
  userPhoto?: string;
  rating: number;
  comment: string;
  createdAt: Date | string;
};
