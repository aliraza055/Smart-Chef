"use client";

import { FormEvent, useEffect, useState } from "react";
import { CheckCheck, Plus, RefreshCw, Tag, Trash2, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";

type CategoryRecord = {
  id: string;
  name: string;
  slug?: string;
  isActive?: boolean;
  createdAt?: unknown;
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

export default function CategoriesPage() {
  const [categories, setCategories] = useState<CategoryRecord[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [error, setError] = useState("");
  const [name, setName] = useState("");

  const refreshCategories = async () => {
    setLoading(true);
    setError("");

    try {
      const response = await fetch("/api/categories", { credentials: "include" });
      if (!response.ok) {
        throw new Error("Unable to load categories.");
      }

      const payload = await response.json();
      setCategories(Array.isArray(payload.categories) ? payload.categories : []);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : "Unable to load categories.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void refreshCategories();
  }, []);

  const handleCreate = async (event: FormEvent) => {
    event.preventDefault();
    if (!name.trim()) {
      setError("Please enter a category name.");
      return;
    }

    setSubmitting(true);
    setError("");

    try {
      const response = await fetch("/api/categories", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "create", name }),
      });

      const payload = await response.json();
      if (!response.ok) {
        throw new Error(payload?.error || "Unable to create category.");
      }

      setCategories((current) => [payload.category, ...current]);
      setName("");
    } catch (createError) {
      setError(createError instanceof Error ? createError.message : "Unable to create category.");
    } finally {
      setSubmitting(false);
    }
  };

  const handleToggle = async (category: CategoryRecord) => {
    const nextState = !(category.isActive ?? true);
    const confirmed = window.confirm(`Set “${category.name}” to ${nextState ? "active" : "inactive"}?`);
    if (!confirmed) return;

    setBusyId(category.id);
    setError("");

    try {
      const response = await fetch("/api/categories", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "toggle", categoryId: category.id, isActive: nextState }),
      });

      const payload = await response.json();
      if (!response.ok) {
        throw new Error(payload?.error || "Unable to update category.");
      }

      setCategories((current) =>
        current.map((item) =>
          item.id === category.id ? { ...item, isActive: nextState } : item,
        ),
      );
    } catch (toggleError) {
      setError(toggleError instanceof Error ? toggleError.message : "Unable to update category.");
    } finally {
      setBusyId(null);
    }
  };

  const handleDelete = async (category: CategoryRecord) => {
    const confirmed = window.confirm(`Delete the “${category.name}” category?`);
    if (!confirmed) return;

    setBusyId(category.id);
    setError("");

    try {
      const response = await fetch("/api/categories", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "delete", categoryId: category.id }),
      });

      const payload = await response.json();
      if (!response.ok) {
        throw new Error(payload?.error || "Unable to delete category.");
      }

      setCategories((current) => current.filter((item) => item.id !== category.id));
    } catch (deleteError) {
      setError(deleteError instanceof Error ? deleteError.message : "Unable to delete category.");
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">Recipe organization</p>
          <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">Categories</h1>
        </div>

        <div className="flex items-center gap-3">
          <Button variant="outline" onClick={() => void refreshCategories()}>
            <RefreshCw className="mr-2 h-4 w-4" />
            Refresh
          </Button>
        </div>
      </div>

      <div className="rounded-xl border border-border bg-surface p-5">
        <form onSubmit={handleCreate} className="flex flex-col gap-3 md:flex-row md:items-end">
          <div className="flex-1">
            <label htmlFor="category-name" className="mb-2 block text-sm font-medium text-foreground">
              Add a category
            </label>
            <input
              id="category-name"
              value={name}
              onChange={(event) => setName(event.target.value)}
              placeholder="e.g. Pasta, Vegan, Dessert"
              className="w-full rounded-lg border border-border bg-background px-3 py-2.5 text-sm text-foreground outline-none ring-0 placeholder:text-muted focus:border-primary"
            />
          </div>

          <Button type="submit" disabled={submitting}>
            <Plus className="mr-2 h-4 w-4" />
            {submitting ? "Adding..." : "Add Category"}
          </Button>
        </form>
      </div>

      <div className="rounded-xl border border-border bg-surface overflow-hidden">
        {error ? <div className="p-6 text-sm text-red-600">{error}</div> : null}

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-border text-left">
            <thead className="bg-background text-sm text-muted">
              <tr>
                <th className="px-4 py-3 font-medium">Category</th>
                <th className="px-4 py-3 font-medium">Slug</th>
                <th className="px-4 py-3 font-medium">Created</th>
                <th className="px-4 py-3 font-medium">Status</th>
                <th className="px-4 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>

            <tbody className="divide-y divide-border text-sm text-foreground">
              {loading ? (
                <tr>
                  <td colSpan={5} className="px-4 py-10 text-center text-muted">
                    Loading categories...
                  </td>
                </tr>
              ) : categories.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-4 py-10 text-center text-muted">
                    No categories found.
                  </td>
                </tr>
              ) : (
                categories.map((category) => {
                  const isActive = category.isActive ?? true;

                  return (
                    <tr key={category.id} className="hover:bg-background/80">
                      <td className="px-4 py-3">
                        <div className="flex items-center gap-3">
                          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
                            <Tag className="h-4 w-4" />
                          </div>
                          <span className="font-medium">{category.name}</span>
                        </div>
                      </td>
                      <td className="px-4 py-3 text-muted">{category.slug || category.id}</td>
                      <td className="px-4 py-3">{formatTimestamp(category.createdAt)}</td>
                      <td className="px-4 py-3">
                        <span
                          className={`inline-flex rounded-full px-2.5 py-1 text-xs font-medium ${
                            isActive ? "bg-emerald-100 text-emerald-700" : "bg-red-100 text-red-700"
                          }`}
                        >
                          {isActive ? "Active" : "Inactive"}
                        </span>
                      </td>
                      <td className="px-4 py-3">
                        <div className="flex items-center justify-end gap-2">
                          <Button
                            variant={isActive ? "outline" : "secondary"}
                            size="sm"
                            onClick={() => void handleToggle(category)}
                            disabled={busyId === category.id}
                          >
                            {isActive ? <XCircle className="mr-1 h-4 w-4" /> : <CheckCheck className="mr-1 h-4 w-4" />}
                            {isActive ? "Disable" : "Enable"}
                          </Button>

                          <Button
                            variant="danger"
                            size="sm"
                            onClick={() => void handleDelete(category)}
                            disabled={busyId === category.id}
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
