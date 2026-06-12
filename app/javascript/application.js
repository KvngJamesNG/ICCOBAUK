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