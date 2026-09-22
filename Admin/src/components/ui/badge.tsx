import React from "react";
import { cn } from "@/lib/utils";

interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?: "default" | "success" | "danger" | "warning";
}

export function Badge({ className, variant = "default", ...props }: BadgeProps) {
  const variants = {
    default: "bg-surface text-foreground border-border",
    success: "bg-primary/10 text-primary border-primary/20",
    danger: "bg-danger/10 text-danger border-danger/20",
    warning: "bg-primary-light/10 text-primary-light border-primary-light/20",
  };

  return (
    <span
      className={cn(
        "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border",
        variants[variant],
        className
      )}
      {...props}
    />
  );
}