/**
 * Appearance control. Three radios and a :has() rule in globals.css — the page
 * follows the system by default, and a reader can force day or dusk without a
 * single line of JavaScript or a stored preference.
 */

const OPTIONS = [
  { id: "appearance-auto", label: "Auto" },
  { id: "appearance-day", label: "Day" },
  { id: "appearance-dusk", label: "Dusk" },
];

export function AppearanceControl() {
  return (
    <fieldset className="border-0 p-0">
      <legend className="text-[10px] font-semibold uppercase tracking-[0.18em] text-sepia">
        Appearance
      </legend>
      <div className="mt-3 inline-flex border border-hairline/60">
        {OPTIONS.map((option, i) => (
          <div key={option.id} className={i > 0 ? "border-l border-hairline/60" : ""}>
            <input
              type="radio"
              name="appearance"
              id={option.id}
              defaultChecked={i === 0}
              className="peer sr-only"
            />
            <label
              htmlFor={option.id}
              className="inline-flex min-h-11 cursor-pointer items-center px-4 text-[13px] font-medium text-ink-muted transition-colors duration-200 ease-out hover:text-ink peer-checked:bg-ink peer-checked:text-paper peer-focus-visible:outline peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2 peer-focus-visible:outline-sage"
            >
              {option.label}
            </label>
          </div>
        ))}
      </div>
    </fieldset>
  );
}
