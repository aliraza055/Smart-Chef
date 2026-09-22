"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Utensils, Flag, MessageSquare, AlertCircle } from "lucide-react";

interface ActivityItem {
  id: string;
  type: string;
  description: string;
  time: string;
}

export function RecentActivity() {
  const [activities, setActivities] = useState<ActivityItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    fetch("/api/dashboard", { credentials: "include" })
      .then((r) => { if (!r.ok) throw new Error("Failed to fetch"); return r.json(); })
      .then((d) => {
        const stats = d.stats;
        const items = [];
        if (stats && stats.newUsers > 0) {
          items.push({ id: "new-users", type: "user_joined", description: `${stats.newUsers} new users joined this week`, time: "This week" });
        }
        if (stats && stats.totalRecipes > 0) {
          items.push({ id: "total-recipes", type: "recipe_published", description: `${stats.totalRecipes} total recipes on the platform`, time: "All time" });
        }
        if (stats && stats.feedback > 0) {
          items.push({ id: "feedback", type: "feedback_submitted", description: `${stats.feedback} reviews submitted`, time: "All time" });
        }
        if (stats && stats.reportedContent > 0) {
          items.push({ id: "reported", type: "recipe_reported", description: `${stats.reportedContent} items reported`, time: "All time" });
        }
        setActivities(items.length ? items : []);
        setLoading(false);
      }).catch(() => {
      setError(true);
      setLoading(false);
    });
  }, []);

  function getActivityIcon(type: string) {
    switch (type) {
      case 'user_joined': return <Users className="h-4 w-4 text-primary" />;
      case 'recipe_published': return <Utensils className="h-4 w-4 text-success" />;
      case 'recipe_reported': return <Flag className="h-4 w-4 text-primary-light" />;
      case 'feedback_submitted': return <MessageSquare className="h-4 w-4 text-primary" />;
      default: return <AlertCircle className="h-4 w-4 text-muted" />;
    }
  }

  if (loading) {
    return (
      <Card>
        <CardHeader><CardTitle>Recent Activity</CardTitle></CardHeader>
        <CardContent>
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="flex gap-4 py-4 animate-pulse">
              <div className="h-8 w-8 rounded-full bg-border shrink-0" />
              <div className="flex-1 space-y-2">
                <div className="h-4 w-full bg-border rounded" />
                <div className="h-3 w-20 bg-border rounded" />
              </div>
            </div>
          ))}
        </CardContent>
      </Card>
    );
  }

  if (error) {
    return (
      <Card>
        <CardHeader><CardTitle>Recent Activity</CardTitle></CardHeader>
        <CardContent><p className="text-muted">Unable to load activity.</p></CardContent>
      </Card>
    );
  }

  if (!activities.length) {
    return (
      <Card>
        <CardHeader><CardTitle>Recent Activity</CardTitle></CardHeader>
        <CardContent><p className="text-muted">No recent activity</p></CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader><CardTitle>Recent Activity</CardTitle></CardHeader>
      <CardContent>
        <div className="space-y-6 mt-4">
          {activities.map((activity) => (
            <div key={activity.id} className="flex gap-4">
              <div className="mt-0.5 h-8 w-8 shrink-0 rounded-full bg-cardBg border border-border flex items-center justify-center">
                {getActivityIcon(activity.type)}
              </div>
              <div className="flex-1 space-y-1">
                <p className="text-sm text-foreground">{activity.description}</p>
                <p className="text-xs text-muted">{activity.time}</p>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
