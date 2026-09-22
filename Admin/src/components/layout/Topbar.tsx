"use client";

import { Bell, Search, Menu, User, LogOut } from "lucide-react";
import { useState } from "react";
import { usePathname } from "next/navigation";
import { navItems } from "./Sidebar";

export default function Topbar({ onMenuClick }: { onMenuClick: () => void }) {
  const [profileOpen, setProfileOpen] = useState(false);
  const pathname = usePathname();

  const currentItem = navItems.find((item) => item.href === pathname);
  const pageTitle = currentItem ? currentItem.name : "Dashboard";

  return (
    <header className="h-16 flex items-center justify-between px-4 sm:px-6 bg-surface border-b border-border sticky top-0 z-10 transition-colors">
      <div className="flex items-center">
        <button
          onClick={onMenuClick}
          className="lg:hidden p-2 -ml-2 mr-2 text-muted hover:text-foreground rounded-md transition-colors"
        >
          <Menu size={20} />
        </button>
        <div className="flex items-center text-lg font-semibold text-foreground">
          {pageTitle}
        </div>
      </div>

      <div className="flex items-center gap-4">
        <div className="relative hidden md:flex items-center">
          <Search size={16} className="absolute left-3 text-muted-light" />
          <input
            type="text"
            placeholder="Search..."
            className="pl-9 pr-4 py-1.5 bg-background border border-border rounded-full text-sm focus:outline-none focus:border-primary-light focus:ring-1 focus:ring-primary-light transition-all w-64 text-foreground"
          />
        </div>

        <button className="relative p-2 text-muted hover:text-primary transition-colors">
          <Bell size={20} />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-primary-light rounded-full border border-surface"></span>
        </button>

        <div className="relative">
          <button
            className="flex items-center gap-2 p-1 rounded-full border border-border hover:bg-background transition-colors"
            onClick={() => setProfileOpen(!profileOpen)}
          >
            <div className="w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center font-bold text-sm shrink-0">
              A
            </div>
            <span className="text-sm font-medium mr-2 hidden sm:block text-foreground">Admin User</span>
          </button>

          {profileOpen && (
            <div className="absolute right-0 mt-2 w-48 bg-surface border border-border rounded-lg shadow-lg py-1 z-50">
              <div className="px-4 py-2 border-b border-border">
                <p className="text-sm font-medium text-foreground">Admin User</p>
                <p className="text-xs text-muted">admin@smartchef.app</p>
              </div>
              <button className="w-full text-left px-4 py-2 text-sm text-foreground hover:bg-background flex items-center gap-2">
                <User size={16} /> Profile
              </button>
              <button className="w-full text-left px-4 py-2 text-sm text-danger hover:bg-red-50 flex items-center gap-2">
                <LogOut size={16} /> Logout
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
