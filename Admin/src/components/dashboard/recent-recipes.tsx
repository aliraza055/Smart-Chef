"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Eye, Edit, Trash2 } from "lucide-react";

interface RecipeData {
  id: string;
  name: string;
  userName?: string;
  category: string;
  createdAt?: { toDate?: () => Date } | Date | string;
  image?: string;
  likes?: number;
  avgRating?: number;
  status?: string;
}

function formatDate(date: any): string {
  if (!date) return "N/A";
  const d = date.toDate ? date.toDate() : new Date(date);
  return d.toISOString().split("T")[0];
}

export function RecentRecipes() {
  const [recipes, setRecipes] = useState<RecipeData[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    fetch("/api/recent-recipes", { credentials: "include" })
      .then((res) => {
        if (!res.ok) throw new Error("Failed to fetch");
        return res.json();
      })
      .then((data) => {
        setRecipes(data.recipes || data);
        setLoading(false);
      })
      .catch(() => {
        setError(true);
        setLoading(false);
      });
  }, []);

  if (loading) {
    return (
      <Card className="col-span-1 lg:col-span-2">
        <CardHeader><CardTitle>Recent Recipes</CardTitle></CardHeader>
        <CardContent className="p-0">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="flex items-center gap-4 px-6 py-4 animate-pulse">
              <div className="h-4 w-48 bg-border rounded" />
              <div className="h-4 w-24 bg-border rounded" />
              <div className="h-4 w-20 bg-border rounded" />
              <div className="h-6 w-16 bg-border rounded" />
            </div>
          ))}
        </CardContent>
      </Card>
    );
  }

  if (error) {
    return (
      <Card className="col-span-1 lg:col-span-2">
        <CardHeader><CardTitle>Recent Recipes</CardTitle></CardHeader>
        <CardContent><p className="text-muted">Unable to load recipes. Please try again.</p></CardContent>
      </Card>
    );
  }

  if (!recipes.length) {
    return (
      <Card className="col-span-1 lg:col-span-2">
        <CardHeader><CardTitle>Recent Recipes</CardTitle></CardHeader>
        <CardContent><p className="text-muted">No recipes found</p></CardContent>
      </Card>
    );
  }

  return (
    <Card className="col-span-1 lg:col-span-2">
      <CardHeader className="flex flex-row items-center justify-between">
        <CardTitle>Recent Recipes</CardTitle>
        <Button variant="outline" size="sm">View All</Button>
      </CardHeader>
      <CardContent className="p-0">
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="text-xs text-muted uppercase bg-cardBg border-y border-border">
              <tr>
                <th className="px-6 py-3 font-medium">Recipe</th>
                <th className="px-6 py-3 font-medium">Author</th>
                <th className="px-6 py-3 font-medium">Category</th>
                <th className="px-6 py-3 font-medium">Created</th>
                <th className="px-6 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border/50">
              {recipes.map((recipe) => (
                <tr key={recipe.id} className="hover:bg-cardBg/50 transition-colors">
                  <td className="px-6 py-4 font-medium text-foreground">{recipe.name}</td>
                  <td className="px-6 py-4 text-muted">{recipe.userName || "Unknown"}</td>
                  <td className="px-6 py-4 text-muted">{recipe.category}</td>
                  <td className="px-6 py-4 text-muted">{formatDate(recipe.createdAt)}</td>
                  <td className="px-6 py-4 text-right">
                    <div className="flex items-center justify-end gap-2">
                      <button className="p-1.5 text-muted hover:text-primary transition-colors">
                        <Eye className="h-4 w-4" />
                      </button>
                      <button className="p-1.5 text-muted hover:text-primary-light transition-colors">
                        <Edit className="h-4 w-4" />
                      </button>
                      <button className="p-1.5 text-muted hover:text-danger transition-colors">
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>
  );
}
