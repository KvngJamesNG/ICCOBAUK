// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

document.documentElement.classList.add("js-enabled")

const COOKIE_CONSENT_KEY = "iccobauk_cookie_consent"

function applyConsent(consent) {
	if (consent === "accepted") {
		window.iccobaukAnalyticsEnabled = true
	} else {
		window.iccobaukAnalyticsEnabled = false
	}
}

function setupCookieConsent() {
	const banner = document.getElementById("cookie-consent-banner")
	if (!banner) return

	const existingConsent = localStorage.getItem(COOKIE_CONSENT_KEY)
	if (existingConsent) {
		applyConsent(existingConsent)
		banner.style.display = "none"
		return
	}

	banner.style.display = "block"

	const acceptButton = document.getElementById("cookie-accept")
	const rejectButton = document.getElementById("cookie-reject")

	acceptButton?.addEventListener("click", () => {
		localStorage.setItem(COOKIE_CONSENT_KEY, "accepted")
		applyConsent("accepted")
		setupClickTracking()
		banner.style.display = "none"
	})

	rejectButton?.addEventListener("click", () => {
		localStorage.setItem(COOKIE_CONSENT_KEY, "rejected")
		applyConsent("rejected")
		banner.style.display = "none"
	})
}

document.addEventListener("turbo:load", setupCookieConsent)

function setupModernAnimations() {
	const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches
	if (reduceMotion) return

	const animatableElements = document.querySelectorAll("section, .card, .feature, .accordion-item, .carousel")
	if (animatableElements.length === 0) return

	animatableElements.forEach((element, index) => {
		element.classList.add("animate-on-scroll")
		element.style.setProperty("--stagger-index", (index % 8).toString())
	})

	const observer = new IntersectionObserver(
		(entries) => {
			entries.forEach((entry) => {
				if (entry.isIntersecting) {
					entry.target.classList.add("is-visible")
					observer.unobserve(entry.target)
				}
			})
		},
		{ threshold: 0.1, rootMargin: "0px 0px -8% 0px" }
	)

	animatableElements.forEach((element) => observer.observe(element))
}

document.addEventListener("turbo:load", setupModernAnimations)

function setupClickTracking() {
	if (!window.iccobaukAnalyticsEnabled) return
	if (window.iccobaukClickTrackingBound) return
	// Don't track clicks on admin pages
	if (window.location.pathname.startsWith("/admin")) return
	window.iccobaukClickTrackingBound = true

	document.addEventListener("click", (event) => {
		const clickable = event.target.closest("a, button")
		if (!clickable) return

		const targetUrl = clickable.tagName === "A" ? clickable.href : ""
		const elementText = (clickable.textContent || "").trim().slice(0, 150)

		fetch("/track-click", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
				"X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content || ""
			},
			body: JSON.stringify({
				path: window.location.pathname,
				target_url: targetUrl,
				element_text: elementText
			}),
			credentials: "same-origin",
			keepalive: true
		}).catch(() => {})
	})
}

document.addEventListener("turbo:load", setupClickTracking)

function setupDropdowns() {
	document.querySelectorAll("[data-bs-toggle='dropdown']").forEach((toggle) => {
		bootstrap.Dropdown.getOrCreateInstance(toggle)
	})
}

document.addEventListener("turbo:load", setupDropdowns)

function setupCarousels() {
	document.querySelectorAll(".carousel").forEach((carouselElement) => {
		bootstrap.Carousel.getOrCreateInstance(carouselElement, {
			interval: Number(carouselElement.dataset.bsInterval || 3500),
			pause: carouselElement.dataset.bsPause || false,
			ride: "carousel",
			touch: true,
			wrap: true
		})
	})
}

document.addEventListener("turbo:load", setupCarousels)

function setupAdminSessionExit() {
	if (!document.body.classList.contains("admin-layout")) return
	if (window.iccobaukAdminExitBound) return
	window.iccobaukAdminExitBound = true

	const exitPath = "/admin/exit"
	const csrfToken = document.querySelector("meta[name='csrf-token']")?.content || ""

	const terminateOnExit = () => {
		const payload = new URLSearchParams({ authenticity_token: csrfToken })
		navigator.sendBeacon(exitPath, payload)
	}

	window.addEventListener("pagehide", terminateOnExit)
	window.addEventListener("beforeunload", terminateOnExit)
}

document.addEventListener("turbo:load", setupAdminSessionExit)

function syncAdminChromeHeight() {
	const chrome = document.getElementById("admin-top-chrome")
	if (!chrome) return

	const chromeHeight = chrome.getBoundingClientRect().height
	document.documentElement.style.setProperty("--admin-chrome-height", `${chromeHeight}px`)

	const sidebar = document.querySelector(".admin-sidebar")
	if (!sidebar) return

	const viewportTarget = Math.max(0, window.innerHeight - chromeHeight)
	let sidebarHeight = viewportTarget

	const footer = document.querySelector(".site-footer")
	if (footer) {
		const footerTop = window.scrollY + footer.getBoundingClientRect().top
		sidebarHeight = Math.max(0, footerTop - chromeHeight - 1)
	} else {
		const docHeight = Math.max(document.documentElement.scrollHeight, document.body.scrollHeight)
		sidebarHeight = Math.max(viewportTarget, docHeight - chromeHeight)
	}

	document.documentElement.style.setProperty("--admin-sidebar-height", `${Math.max(0, Math.round(sidebarHeight))}px`)
}

function scheduleAdminChromeSync() {
	requestAnimationFrame(syncAdminChromeHeight)
	setTimeout(syncAdminChromeHeight, 80)
	setTimeout(syncAdminChromeHeight, 320)
}

function isAdminContentLongPage() {
	const appContent = document.getElementById("app-content")
	if (!appContent) return document.documentElement.scrollHeight > window.innerHeight + 20

	const contentChildren = Array.from(appContent.children).filter((child) => !child.classList.contains("site-footer"))
	if (contentChildren.length === 0) return false

	let contentBottom = 0
	contentChildren.forEach((child) => {
		const rect = child.getBoundingClientRect()
		contentBottom = Math.max(contentBottom, window.scrollY + rect.bottom)
	})

	return contentBottom > window.innerHeight + 20
}

function setupAdminSidebarOverflow() {
	const sidebar = document.querySelector(".admin-sidebar")
	const toggle = document.getElementById("admin-sidebar-overflow-toggle")
	const overflow = document.getElementById("admin-sidebar-overflow")
	if (!sidebar || !toggle || !overflow) return

	const isLongPage = isAdminContentLongPage()
	toggle.hidden = !isLongPage

	if (!isLongPage) {
		overflow.classList.remove("is-collapsed")
		toggle.setAttribute("aria-expanded", "true")
		delete toggle.dataset.userPreference
	} else {
		const userPreference = toggle.dataset.userPreference
		if (userPreference === "expanded") {
			overflow.classList.remove("is-collapsed")
			toggle.setAttribute("aria-expanded", "true")
		} else {
			overflow.classList.add("is-collapsed")
			toggle.setAttribute("aria-expanded", "false")
		}
	}

	if (toggle.dataset.bound !== "true") {
		toggle.dataset.bound = "true"
		toggle.addEventListener("click", () => {
			const expanded = toggle.getAttribute("aria-expanded") === "true"
			const nextExpanded = !expanded
			toggle.setAttribute("aria-expanded", nextExpanded ? "true" : "false")
			overflow.classList.toggle("is-collapsed", !nextExpanded)
			toggle.dataset.userPreference = nextExpanded ? "expanded" : "collapsed"
			scheduleAdminChromeSync()
		})
	}
}

function setupDashboardMoreMinimize() {
	const more = document.getElementById("dashboard-more")
	const summary = document.getElementById("dashboard-summary")
	if (!more || !summary) return

	if (summary.dataset.bound !== "true") {
		summary.dataset.bound = "true"

		const syncSummary = () => {
			summary.classList.toggle("is-minimized", more.classList.contains("show"))
			scheduleAdminChromeSync()
		}

		more.addEventListener("shown.bs.collapse", syncSummary)
		more.addEventListener("hidden.bs.collapse", syncSummary)
		more.addEventListener("show.bs.collapse", scheduleAdminChromeSync)
		more.addEventListener("hide.bs.collapse", scheduleAdminChromeSync)
		syncSummary()
	}
}

function dismissFlash(element) {
	if (!element || element.dataset.dismissed === "true") return
	element.dataset.dismissed = "true"
	element.classList.add("is-hiding")
	setTimeout(() => element.remove(), 200)
}

function setupFloatingFlashMessages() {
	document.querySelectorAll(".flash-floating").forEach((flash, index) => {
		if (flash.dataset.bound === "true") return
		flash.dataset.bound = "true"

		const closeButton = flash.querySelector("[data-flash-close='true']")
		closeButton?.addEventListener("click", () => dismissFlash(flash))

		if (flash.dataset.autodismiss === "true") {
			const delay = 4200 + index * 300
			setTimeout(() => dismissFlash(flash), delay)
		}
	})
}

document.addEventListener("turbo:load", scheduleAdminChromeSync)
document.addEventListener("turbo:render", scheduleAdminChromeSync)
document.addEventListener("turbo:load", setupAdminSidebarOverflow)
document.addEventListener("turbo:render", setupAdminSidebarOverflow)
document.addEventListener("turbo:load", setupDashboardMoreMinimize)
document.addEventListener("turbo:render", setupDashboardMoreMinimize)
document.addEventListener("turbo:load", setupFloatingFlashMessages)
window.addEventListener("load", scheduleAdminChromeSync)
window.addEventListener("load", setupAdminSidebarOverflow)
window.addEventListener("load", setupDashboardMoreMinimize)
window.addEventListener("resize", scheduleAdminChromeSync)
window.addEventListener("resize", setupAdminSidebarOverflow)