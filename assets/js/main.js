(() => {
  const root = document.documentElement;
  const toggle = document.querySelector("[data-theme-toggle]");
  const storageKey = "blog-color-theme";

  const saved = localStorage.getItem(storageKey);
  if (saved === "light" || saved === "dark") {
    root.dataset.theme = saved;
  }

  if (!toggle) return;

  const currentTheme = () => {
    if (root.dataset.theme) return root.dataset.theme;
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  };

  const updateLabel = () => {
    const next = currentTheme() === "dark" ? "light" : "dark";
    toggle.setAttribute("aria-label", `Switch to ${next} theme`);
  };

  updateLabel();
  toggle.addEventListener("click", () => {
    const next = currentTheme() === "dark" ? "light" : "dark";
    root.dataset.theme = next;
    localStorage.setItem(storageKey, next);
    updateLabel();
  });
})();
