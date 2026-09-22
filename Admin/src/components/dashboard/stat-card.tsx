"use client";

import { useState, useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";
import { LucideIcon } from "lucide-react";

interface StatCardProps {
  title: string;
  icon: LucideIcon;
  trend?: string;
  trendUp?: boolean;
}

export function StatCard({ title, value, icon: Icon, trend, trendUp }: StatCardProps & { value: string | number }) {
  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm font-medium text-muted">{title}</p>
            <h4 className="text-2xl font-bold text-foreground mt-2">{value}</h4>
          </div>
          <div className="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center">
            <Icon className="h-6 w-6 text-primary" />
          </div>
        </div>
        {trend && (
          <div className="mt-4 flex items-center text-sm">
            <span className={cn("font-medium", trendUp ? "text-success" : "text-danger")}>
              {trendUp ? "+" : "-"}{trend}
            </span>
            <span className="text-muted ml-2">from last month</span>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

export function StatCardSkeleton() {
  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <div>
            <div className="h-4 w-24 bg-border rounded animate-pulse" />
            <div className="h-8 w-16 bg-border rounded animate-pulse mt-2" />
          </div>
          <div className="h-12 w-12 rounded-full bg-border animate-pulse" />
        </div>
      </CardContent>
    </Card>
  );
}
