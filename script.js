// Infotopの購入URLが決まったら、空文字をURLに置き換えてください。
const PURCHASE_URL = "";

document.querySelectorAll(".purchase-link").forEach((link) => {
  if (PURCHASE_URL) {
    link.href = PURCHASE_URL;
    link.target = "_blank";
    link.rel = "noopener noreferrer";
  }
});

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.12 }
);

document.querySelectorAll(".reveal").forEach((element, index) => {
  element.style.transitionDelay = `${Math.min(index % 4, 3) * 70}ms`;
  observer.observe(element);
});
