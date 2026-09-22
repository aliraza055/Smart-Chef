"use client";

import { useEffect, useState } from "react";
import {
  AlertTriangle,
  ArrowUpRight,
  BookOpen,
  MessageSquareText,
  Sparkles,
  UserPlus,
  Users,
} from "lucide-react";
import { StatCard } from "@/components/dashboard/stat-card";
import { UserGrowthChart } from "@/components/dashboard/user-growth-chart";
import { RecipeStats } from "@/components/dashboard/recipe-stats";
import { RecentActivity } from "@/components/dashboard/recent-activity";
import { RecentRecipes } from "@/components/dashboard/recent-recipes";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

type MetricValue = number | { status: string; reason: string };

interface DashboardResponse {
  stats: {
    totalUsers: number;
    activeUsers: MetricValue;
    totalRecipes: number;
    reportedContent: MetricValue;
    feedback: number;
    newUsers: number;
  };
  recentRecipes: unknown[];
  recipeStats: Record<string, number>;
  userGrowthData: unknown[];
}

export default function Home() {
  const [data, setData] = useState<DashboardResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    fetchDashboard();
  }, []);

  async function fetchDashboard() {
    try {
      const res = await fetch("/api/dashboard", { credentials: "include" });
      if (!res.ok) throw new Error("Failed to fetch");
      const d = await res.json();
      setData(d);
    } catch {
      setError(true);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">
              SmartChef overview
            </p>
            <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">
              Admin Dashboard
            </h1>
          </div>
        </div>
        <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
          {Array.from({ length: 6 }).map((_, i) => (
            <div key={i} className="animate-pulse">
              <div className="h-24 bg-border rounded-xl" />
            </div>
          ))}
        </section>
        <section className="grid gap-6 xl:grid-cols-[1.7fr_1fr]">
          <div className="h-[300px] bg-border rounded-xl animate-pulse" />
          <div className="h-[300px] bg-border rounded-xl animate-pulse" />
        </section>
        <div className="h-[200px] bg-border rounded-xl animate-pulse" />
      </div>
    );
  }

  if (error || !data) {
    return (
      <div className="space-y-6">
        <section className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">
              SmartChef overview
            </p>
            <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">
              Admin Dashboard
            </h1>
          </div>
        </section>
        <Card>
          <CardContent className="p-8 text-center">
            <p className="text-muted text-lg">
              Unable to load dashboard data. Please try again.
            </p>
            <Button variant="outline" size="md" className="mt-4" onClick={fetchDashboard}>
              Retry
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  const stats = data.stats;

  const formatMetric = (value: MetricValue) =>
    typeof value === "number" ? value : "N/A";

  const overviewStats = [
    { title: "Total Users", value: stats.totalUsers, icon: Users, trend: "12%", trendUp: true },
    { title: "Active Users", value: formatMetric(stats.activeUsers), icon: UserPlus, trend: "N/A", trendUp: true },
    { title: "Total Recipes", value: stats.totalRecipes, icon: BookOpen, trend: `${stats.totalRecipes}`, trendUp: true },
    { title: "Reported Content", value: formatMetric(stats.reportedContent), icon: AlertTriangle, trend: "N/A", trendUp: false },
    { title: "Feedback", value: stats.feedback, icon: MessageSquareText, trend: "2%", trendUp: true },
    { title: "New Users", value: stats.newUsers, icon: Sparkles, trend: "15%", trendUp: true },
  ];

  const quickActions = [
    "Add Category", "View Users", "View Recipes", "View Reports", "View Feedback",
  ];

  return (
    <div className="space-y-6">
      <section className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">
            SmartChef overview
          </p>
          <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">
            Admin Dashboard
          </h1>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Button variant="outline" size="md">Export Report</Button>
          <Button variant="primary" size="md">+ New Recipe</Button>
        </div>
      </section>

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
        {overviewStats.map((stat) => (
          <StatCard key={stat.title} title={stat.title} value={stat.value} icon={stat.icon} trend={stat.trend} trendUp={stat.trendUp} />
        ))}
      </section>

      <section className="grid gap-6 xl:grid-cols-[1.7fr_1fr]">
        <UserGrowthChart />
        <RecipeStats />
      </section>

      <section className="grid gap-6 xl:grid-cols-[1.5fr_0.8fr]">
        <RecentActivity />
        <Card>
          <CardHeader><CardTitle>Quick Actions</CardTitle></CardHeader>
          <CardContent className="space-y-3">
            {quickActions.map((action) => (
              <button key={action} type="button" className="flex w-full items-center justify-between rounded-xl border border-border bg-[var(--cardBg)] px-4 py-3 text-left text-sm font-medium text-foreground transition-colors hover:border-primary/40 hover:bg-[var(--primary-soft)]">
                <span>{action}</span>
                <ArrowUpRight className="h-4 w-4 text-muted" />
              </button>
            ))}
          </CardContent>
        </Card>
      </section>

      <RecentRecipes />
    </div>
  );
}
