"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Area, AreaChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";

interface UserGrowthPoint {
  date: string;
  users: number;
}

export function UserGrowthChart() {
  const [data, setData] = useState<UserGrowthPoint[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    fetch("/api/dashboard", { credentials: "include" })
      .then((res) => {
        if (!res.ok) throw new Error("Failed to fetch");
        return res.json();
      })
      .then((responseData) => {
        const growthData = responseData.userGrowthData || [];
        setData(growthData);
        setLoading(false);
      })
      .catch(() => {
        setError(true);
        setLoading(false);
      });
  }, []);

  const formatLabel = (dateStr: string) => {
    const d = new Date(dateStr);
    return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
  };

  if (loading) {
    return (
      <Card className="col-span-1 lg:col-span-2">
        <CardHeader><CardTitle>User Growth</CardTitle></CardHeader>
        <CardContent><div className="h-[300px] w-full mt-4 animate-pulse bg-border rounded" /></CardContent>
      </Card>
    );
  }

  if (error || !data.length) {
    return (
      <Card className="col-span-1 lg:col-span-2">
        <CardHeader><CardTitle>User Growth</CardTitle></CardHeader>
        <CardContent><p className="text-muted">No growth data available.</p></CardContent>
      </Card>
    );
  }

  return (
    <Card className="col-span-1 lg:col-span-2">
      <CardHeader><CardTitle>User Growth</CardTitle></CardHeader>
      <CardContent>
        <div className="h-[300px] w-full mt-4">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={data} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
              <defs>
                <linearGradient id="colorUsers" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="var(--color-primary)" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="var(--color-primary)" stopOpacity={0} />
                </linearGradient>
              </defs>
              <XAxis dataKey="date" stroke="var(--color-muted)" fontSize={12} tickLine={false} axisLine={false} tickFormatter={formatLabel} />
              <YAxis stroke="var(--color-muted)" fontSize={12} tickLine={false} axisLine={false} />
              <Tooltip
                contentStyle={{ backgroundColor: 'var(--color-surface)', borderColor: 'var(--color-border)', borderRadius: '8px' }}
                itemStyle={{ color: 'var(--color-primary)', fontWeight: 'bold' }}
              />
              <Area type="monotone" dataKey="users" stroke="var(--color-primary)" strokeWidth={3} fillOpacity={1} fill="url(#colorUsers)" />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  );
}
