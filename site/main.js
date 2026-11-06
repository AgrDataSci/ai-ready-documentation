// maniva site behaviour: copy buttons, the question router, and the live version.
// Interface messages come from the #i18n block, which the build fills per language.

(function () {
  "use strict";

  var t = {
    copied: "Copied. Paste it into your assistant.",
    copyFail: "Select the text and copy it with your keyboard.",
    citationCopied: "Citation copied.",
    routeTo: "maniva sends this question to ",
    and: " and ",
    commit: "commit",
    layers: { knowledge: "the knowledge base", protocols: "protocols", data: "data", analysis: "analysis" }
  };
  try {
    var block = document.getElementById("i18n");
    if (block) {
      var custom = JSON.parse(block.textContent);
      Object.keys(custom).forEach(function (k) { t[k] = custom[k]; });
    }
  } catch (e) {}
  var root = document.documentElement.getAttribute("data-root") || "";

  // Copy buttons
  document.querySelectorAll("[data-copy]").forEach(function (button) {
    button.addEventListener("click", function () {
      var source = document.querySelector(button.getAttribute("data-copy"));
      var status = button.parentElement.parentElement.querySelector(".copy-status") ||
        button.parentElement.querySelector(".copy-status");
      var text = "value" in source ? source.value : source.textContent.trim();
      var done = function (ok) {
        if (!status) return;
        status.textContent = ok ? t.copied : t.copyFail;
        if (ok && button.getAttribute("data-copy") === "#citation") status.textContent = t.citationCopied;
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
      var list = wanted.map(function (k) { return t.layers[k]; });
      var phrase = list.length > 1 ? list.slice(0, -1).join(", ") + t.and + list[list.length - 1] : list[0];
      note.textContent = t.routeTo + phrase + ".";
    });
  });

  // Live version from version.json on main, with the copy deployed alongside the site as fallback
  var show = function (v) {
    if (!v || !v.version) return;
    document.querySelectorAll("[data-version]").forEach(function (el) { el.textContent = v.version; });
    if (v.commit) {
      document.querySelectorAll("[data-commit]").forEach(function (el) {
        el.innerHTML = ", " + t.commit + " <a href=\"https://github.com/AgrDataSci/maniva/commit/" + v.commit + "\">" + v.commit.slice(0, 7) + "</a>";
      });
    }
  };
  fetch("https://raw.githubusercontent.com/AgrDataSci/maniva/main/version.json", { cache: "no-store" })
    .then(function (r) { if (!r.ok) throw new Error(); return r.json(); })
    .catch(function () { return fetch(root + "version.json").then(function (r) { return r.json(); }); })
    .then(show)
    .catch(function () {});
})();
