"use client";

import { useEffect, useState } from "react";
import { Area, AreaChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { Activity, AlertTriangle, BookOpen, MessageSquareText, TrendingUp, Users } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

type AnalyticsData = {
  metrics: {
    totalUsers: number;
    totalRecipes: number;
    totalReviews: number;
    newUsers: number;
    reportedContent: number;
    feedbackCount: number;
  };
  recipeStats: {
    total: number;
    published: number;
    hidden: number;
    reported: number;
  };
  userGrowthData: Array<{ date: string; users: number }>;
};

export default function AnalyticsPage() {
  const [data, setData] = useState<AnalyticsData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchAnalytics = async () => {
      try {
        const res = await fetch("/api/analytics", { credentials: "include" });
        if (!res.ok) throw new Error("Unable to load analytics.");

        const payload = await res.json();
        setData(payload);
      } catch (loadError) {
        setError(loadError instanceof Error ? loadError.message : "Unable to load analytics.");
      } finally {
        setLoading(false);
      }
    };

    void fetchAnalytics();
  }, []);

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="h-8 w-48 animate-pulse rounded bg-border" />
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
          {Array.from({ length: 6 }).map((_, index) => (
            <div key={index} className="h-28 animate-pulse rounded-xl bg-border" />
          ))}
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <div className="rounded-xl border border-border bg-surface p-6 text-sm text-red-600">
        {error || "Analytics unavailable."}
      </div>
    );
  }

  const metricCards = [
    { label: "Total Users", value: data.metrics.totalUsers, icon: Users, tint: "text-primary" },
    { label: "Total Recipes", value: data.metrics.totalRecipes, icon: BookOpen, tint: "text-emerald-500" },
    { label: "Reviews", value: data.metrics.totalReviews, icon: MessageSquareText, tint: "text-violet-500" },
    { label: "New Users (7d)", value: data.metrics.newUsers, icon: TrendingUp, tint: "text-cyan-500" },
    { label: "Reported Items", value: data.metrics.reportedContent, icon: AlertTriangle, tint: "text-amber-500" },
    { label: "Feedback", value: data.metrics.feedbackCount, icon: Activity, tint: "text-pink-500" },
  ];

  const formatLabel = (value: string) => {
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return value;
    return date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
  };

  const publishedPercent = data.recipeStats.total > 0 ? Math.round((data.recipeStats.published / data.recipeStats.total) * 100) : 0;

  return (
    <div className="space-y-6">
      <div>
        <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">Platform insights</p>
        <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">Analytics</h1>
      </div>

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
        {metricCards.map(({ label, value, icon: Icon, tint }) => (
          <div key={label} className="rounded-xl border border-border bg-surface p-5">
            <div className="flex items-center justify-between">
              <span className="text-sm text-muted">{label}</span>
              <Icon className={`h-4 w-4 ${tint}`} />
            </div>
            <div className="mt-4 text-3xl font-bold text-foreground">{value}</div>
          </div>
        ))}
      </section>

      <section className="grid gap-6 xl:grid-cols-[1.8fr_1fr]">
        <Card>
          <CardHeader>
            <CardTitle>User Growth</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[320px] w-full">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={data.userGrowthData} margin={{ top: 10, right: 12, left: 0, bottom: 0 }}>
                  <defs>
                    <linearGradient id="analyticsFill" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="var(--color-primary)" stopOpacity={0.35} />
                      <stop offset="95%" stopColor="var(--color-primary)" stopOpacity={0.05} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="var(--color-border)" />
                  <XAxis dataKey="date" tickFormatter={formatLabel} stroke="var(--color-muted)" fontSize={12} axisLine={false} tickLine={false} />
                  <YAxis stroke="var(--color-muted)" fontSize={12} axisLine={false} tickLine={false} />
                  <Tooltip
                    contentStyle={{ backgroundColor: "var(--color-surface)", border: "1px solid var(--color-border)", borderRadius: 10 }}
                  />
                  <Area type="monotone" dataKey="users" stroke="var(--color-primary)" strokeWidth={3} fill="url(#analyticsFill)" />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Recipe Status</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted">Published</span>
                <span className="font-bold text-foreground">{data.recipeStats.published}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted">Hidden</span>
                <span className="font-bold text-foreground">{data.recipeStats.hidden}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted">Reported</span>
                <span className="font-bold text-foreground">{data.recipeStats.reported}</span>
              </div>
              <div className="pt-4 border-t border-border">
                <div className="flex items-center justify-between text-xs text-muted">
                  <span>Healthy recipes</span>
                  <span>{publishedPercent}%</span>
                </div>
                <div className="mt-2 h-2 w-full overflow-hidden rounded-full bg-background">
                  <div className="h-full rounded-full bg-emerald-500" style={{ width: `${publishedPercent}%` }} />
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </section>
    </div>
  );
}
