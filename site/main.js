// maniva site behaviour: copy buttons, the question router, and the live version.

(function () {
  "use strict";

  // Copy buttons
  document.querySelectorAll("[data-copy]").forEach(function (button) {
    button.addEventListener("click", function () {
      var source = document.querySelector(button.getAttribute("data-copy"));
      var status = button.parentElement.parentElement.querySelector(".copy-status") ||
        button.parentElement.querySelector(".copy-status");
      var text = "value" in source ? source.value : source.textContent.trim();
      var done = function (ok) {
        if (!status) return;
        status.textContent = ok ? "Copied. Paste it into your assistant." : "Select the text and copy it with your keyboard.";
        if (ok && button.getAttribute("data-copy") === "#citation") status.textContent = "Citation copied.";
      };
      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text).then(function () { done(true); }, function () { done(false); });
      } else {
        if (source.select) source.select();
        done(false);
      }
    });
  });

  // Question router: highlight the layers that answer the chosen question
  var router = document.querySelector(".router");
  var note = document.querySelector(".route-note");
  var names = { knowledge: "the knowledge base", protocols: "protocols", data: "data", analysis: "analysis" };
  var questions = router ? router.querySelectorAll(".q") : [];

  questions.forEach(function (q) {
    q.addEventListener("click", function () {
      var wasOn = q.getAttribute("aria-pressed") === "true";
      questions.forEach(function (other) { other.setAttribute("aria-pressed", "false"); });
      router.querySelectorAll(".layer").forEach(function (l) { l.classList.remove("is-lit"); });

      if (wasOn) {
        router.classList.remove("is-routing");
        note.textContent = "";
        return;
      }

      q.setAttribute("aria-pressed", "true");
      router.classList.add("is-routing");
      var wanted = q.getAttribute("data-layers").split(" ");
      wanted.forEach(function (key) {
        var row = router.querySelector('.layer[data-layer="' + key + '"]');
        if (row) row.classList.add("is-lit");
      });
      var list = wanted.map(function (k) { return names[k]; });
      var phrase = list.length > 1 ? list.slice(0, -1).join(", ") + " and " + list[list.length - 1] : list[0];
      note.textContent = "maniva sends this question to " + phrase + ".";
    });
  });

  // Live version from version.json on main, with the copy deployed alongside the site as fallback
  var show = function (v) {
    if (!v || !v.version) return;
    document.querySelectorAll("[data-version]").forEach(function (el) { el.textContent = v.version; });
    if (v.commit) {
      document.querySelectorAll("[data-commit]").forEach(function (el) {
        el.innerHTML = ", commit <a href=\"https://github.com/AgrDataSci/maniva/commit/" + v.commit + "\">" + v.commit.slice(0, 7) + "</a>";
      });
    }
  };
  fetch("https://raw.githubusercontent.com/AgrDataSci/maniva/main/version.json", { cache: "no-store" })
    .then(function (r) { if (!r.ok) throw new Error(); return r.json(); })
    .catch(function () { return fetch("version.json").then(function (r) { return r.json(); }); })
    .then(show)
    .catch(function () {});
})();
