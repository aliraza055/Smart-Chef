"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Utensils, CheckCircle, EyeOff, AlertTriangle } from "lucide-react";

interface RecipeStatsData {
  total: number;
  published: number;
  hidden: number;
  reported: number;
}

export function RecipeStats() {
  const [stats, setStats] = useState<RecipeStatsData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    fetch("/api/dashboard", { credentials: "include" })
      .then((res) => {
        if (!res.ok) throw new Error("Failed to fetch");
        return res.json();
      })
      .then((data) => {
        setStats(data.recipeStats);
        setLoading(false);
      })
      .catch(() => {
        setError(true);
        setLoading(false);
      });
  }, []);

  if (loading) {
    return (
      <Card>
        <CardHeader><CardTitle>Recipe Overview</CardTitle></CardHeader>
        <CardContent>
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="flex items-center justify-between py-4 animate-pulse">
              <div className="flex items-center gap-3">
                <div className="h-8 w-8 bg-border rounded-lg" />
                <div className="h-4 w-32 bg-border rounded" />
              </div>
              <div className="h-6 w-16 bg-border rounded" />
            </div>
          ))}
        </CardContent>
      </Card>
    );
  }

  if (error || !stats) {
    return (
      <Card>
        <CardHeader><CardTitle>Recipe Overview</CardTitle></CardHeader>
        <CardContent><p className="text-muted">Unable to load recipe statistics.</p></CardContent>
      </Card>
    );
  }

  const total = stats.total || 1;
  const healthyPercent = Math.round((stats.published / total) * 100) || 0;

  return (
    <Card>
      <CardHeader><CardTitle>Recipe Overview</CardTitle></CardHeader>
      <CardContent>
        <div className="space-y-6 mt-2">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-primary/10 rounded-lg"><Utensils className="h-5 w-5 text-primary" /></div>
              <span className="font-medium text-foreground">Total Recipes</span>
            </div>
            <span className="font-bold text-foreground">{stats.total}</span>
          </div>
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-success/10 rounded-lg"><CheckCircle className="h-5 w-5 text-success" /></div>
              <span className="font-medium text-foreground">Published</span>
            </div>
            <span className="font-bold text-foreground">{stats.published}</span>
          </div>
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-muted/10 rounded-lg"><EyeOff className="h-5 w-5 text-muted" /></div>
              <span className="font-medium text-foreground">Hidden</span>
            </div>
            <span className="font-bold text-foreground">{stats.hidden}</span>
          </div>
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-danger/10 rounded-lg"><AlertTriangle className="h-5 w-5 text-danger" /></div>
              <span className="font-medium text-foreground">Reported</span>
            </div>
            <span className="font-bold text-foreground">{stats.reported}</span>
          </div>
        </div>
        <div className="mt-8 pt-6 border-t border-border">
          <div className="flex h-2 w-full overflow-hidden rounded-full bg-card-bg">
            <div className="bg-success" style={{ width: `${healthyPercent}%` }} />
            <div className="bg-muted" style={{ width: `${stats.hidden ? Math.round((stats.hidden / total) * 100) : 0}%` }} />
            <div className="bg-danger" style={{ width: `${stats.reported ? Math.round((stats.reported / total) * 100) : 0}%` }} />
          </div>
          <div className="mt-2 flex justify-between text-xs text-muted">
            <span>{healthyPercent}% Healthy</span>
            <span>Needs Review</span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
