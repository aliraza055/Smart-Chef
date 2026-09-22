"use client";

import { useEffect, useMemo, useState } from "react";
import { Eye, EyeOff, RefreshCw, Trash2, UtensilsCrossed } from "lucide-react";
import { Button } from "@/components/ui/button";

type RecipeRecord = {
  id: string;
  name?: string;
  title?: string;
  category?: string;
  author?: string;
  userName?: string;
  createdBy?: string;
  createdAt?: unknown;
  status?: string;
  likes?: number;
};

const formatTimestamp = (value: unknown) => {
  if (!value) return "—";

  if (typeof value === "string") {
    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? value : date.toLocaleDateString();
  }

  if (typeof value === "number") {
    return new Date(value).toLocaleDateString();
  }

  if (value && typeof value === "object" && "toDate" in value && typeof (value as { toDate: () => Date }).toDate === "function") {
    return (value as { toDate: () => Date }).toDate().toLocaleDateString();
  }

  return String(value);
};

const getStatusLabel = (status?: string) => {
  const normalized = String(status || "active").toLowerCase();
  if (normalized === "hidden") return "Hidden";
  if (normalized === "reported") return "Reported";
  return "Active";
};

export default function RecipesPage() {
  const [recipes, setRecipes] = useState<RecipeRecord[]>([]);
  const [loading, setLoading] = useState(true);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [error, setError] = useState("");

  const refreshRecipes = async () => {
    setLoading(true);
    setError("");

    try {
      const response = await fetch("/api/recipes", { credentials: "include" });
      if (!response.ok) {
        throw new Error("Unable to load recipes.");
      }

      const payload = await response.json();
      setRecipes(Array.isArray(payload.recipes) ? payload.recipes : []);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : "Unable to load recipes.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void refreshRecipes();
  }, []);

  const totalRecipes = useMemo(() => recipes.length, [recipes]);
  const hiddenRecipes = useMemo(
    () => recipes.filter((recipe) => String(recipe.status || "active").toLowerCase() === "hidden").length,
    [recipes],
  );

  const handleToggleStatus = async (recipe: RecipeRecord) => {
    const isHidden = String(recipe.status || "active").toLowerCase() === "hidden";
    const nextStatus = isHidden ? "active" : "hidden";
    const actionLabel = isHidden ? "publish" : "hide";
    const confirmed = window.confirm(`Are you sure you want to ${actionLabel} ${recipe.name || recipe.title || "this recipe"}?`);

    if (!confirmed) return;

    setBusyId(recipe.id);
    setError("");

    try {
      const response = await fetch("/api/recipes", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "toggleStatus", recipeId: recipe.id, status: nextStatus }),
      });

      if (!response.ok) {
        throw new Error("Unable to update the recipe status.");
      }

      setRecipes((current) =>
        current.map((item) =>
          item.id === recipe.id ? { ...item, status: nextStatus } : item,
        ),
      );
    } catch (updateError) {
      setError(updateError instanceof Error ? updateError.message : "Unable to update the recipe.");
    } finally {
      setBusyId(null);
    }
  };

  const handleDeleteRecipe = async (recipe: RecipeRecord) => {
    const label = recipe.name || recipe.title || "this recipe";
    const confirmed = window.confirm(`This will permanently delete ${label}. Continue?`);

    if (!confirmed) return;

    setBusyId(recipe.id);
    setError("");

    try {
      const response = await fetch("/api/recipes", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "deleteRecipe", recipeId: recipe.id }),
      });

      if (!response.ok) {
        throw new Error("Unable to delete the recipe.");
      }

      setRecipes((current) => current.filter((item) => item.id !== recipe.id));
    } catch (deleteError) {
      setError(deleteError instanceof Error ? deleteError.message : "Unable to delete the recipe.");
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">Recipe management</p>
          <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">Recipes</h1>
        </div>

        <div className="flex items-center gap-3">
          <Button variant="outline" onClick={() => void refreshRecipes()}>
            <RefreshCw className="mr-2 h-4 w-4" />
            Refresh
          </Button>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Total recipes</span>
            <UtensilsCrossed className="h-4 w-4 text-primary" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{totalRecipes}</div>
        </div>

        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Visible</span>
            <Eye className="h-4 w-4 text-emerald-500" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{totalRecipes - hiddenRecipes}</div>
        </div>

        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Hidden</span>
            <EyeOff className="h-4 w-4 text-red-500" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{hiddenRecipes}</div>
        </div>
      </div>

      <div className="rounded-xl border border-border bg-surface overflow-hidden">
        {error ? <div className="p-6 text-sm text-red-600">{error}</div> : null}

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-border text-left">
            <thead className="bg-background text-sm text-muted">
              <tr>
                <th className="px-4 py-3 font-medium">Recipe</th>
                <th className="px-4 py-3 font-medium">Author</th>
                <th className="px-4 py-3 font-medium">Category</th>
                <th className="px-4 py-3 font-medium">Created</th>
                <th className="px-4 py-3 font-medium">Status</th>
                <th className="px-4 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>

            <tbody className="divide-y divide-border text-sm text-foreground">
              {loading ? (
                <tr>
                  <td colSpan={6} className="px-4 py-10 text-center text-muted">
                    Loading recipes...
                  </td>
                </tr>
              ) : recipes.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-4 py-10 text-center text-muted">
                    No recipes found.
                  </td>
                </tr>
              ) : (
                recipes.map((recipe) => {
                  const isHidden = String(recipe.status || "active").toLowerCase() === "hidden";
                  const statusLabel = getStatusLabel(recipe.status);

                  return (
                    <tr key={recipe.id} className="hover:bg-background/80">
                      <td className="px-4 py-3">
                        <div>
                          <div className="font-medium">{recipe.name || recipe.title || "Untitled recipe"}</div>
                          <div className="text-xs text-muted">{recipe.id.slice(0, 8)}</div>
                        </div>
                      </td>
                      <td className="px-4 py-3">{recipe.author || recipe.userName || recipe.createdBy || "Unknown"}</td>
                      <td className="px-4 py-3">{recipe.category || "Uncategorized"}</td>
                      <td className="px-4 py-3">{formatTimestamp(recipe.createdAt)}</td>
                      <td className="px-4 py-3">
                        <span
                          className={`inline-flex rounded-full px-2.5 py-1 text-xs font-medium ${
                            isHidden ? "bg-red-100 text-red-700" : "bg-emerald-100 text-emerald-700"
                          }`}
                        >
                          {statusLabel}
                        </span>
                      </td>
                      <td className="px-4 py-3">
                        <div className="flex items-center justify-end gap-2">
                          <Button
                            variant={isHidden ? "secondary" : "outline"}
                            size="sm"
                            onClick={() => void handleToggleStatus(recipe)}
                            disabled={busyId === recipe.id}
                          >
                            {isHidden ? <Eye className="mr-1 h-4 w-4" /> : <EyeOff className="mr-1 h-4 w-4" />}
                            {isHidden ? "Publish" : "Hide"}
                          </Button>

                          <Button
                            variant="danger"
                            size="sm"
                            onClick={() => void handleDeleteRecipe(recipe)}
                            disabled={busyId === recipe.id}
                          >
                            <Trash2 className="mr-1 h-4 w-4" />
                            Delete
                          </Button>
                        </div>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
