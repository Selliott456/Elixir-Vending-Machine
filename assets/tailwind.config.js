// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require("tailwindcss/plugin");

const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    screen: {
      sm: "480px",
      md: "768px",
      lg: "976px",
      xl: "1440px",
    },
    fontSize: {
      xs: ["13px", "18px"],
      sm: ["14px", "20px"],
      base: ["16px", "24px"],
      lg: ["18px", "27px"],
      xl: ["20px", "30px"],
      "2xl": ["24px", "36px"],
      "3xl": ["30px", "45px"],
      "4xl": ["40px", "55px"],
    },
    extend: {
      backgroundImage: {
        hero: "url(/images/sweet.svg)",
      },
      colors: {
        primaryOrange: "#E27D60",
        primaryVariantOrange: "#E8A87C",
        secondaryGreen: "#41B3A3",
        secondaryPink: "#C38D9E",
        spacerGrey: "#F3F0F8",
        brandBlack: "#0C001C",
      },
      fontFamily: {
        sans: ["Montserrat", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/line-clamp"),
    require("@tailwindcss/forms"),
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", ["&.phx-no-feedback", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        "&.phx-click-loading",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        "&.phx-submit-loading",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        "&.phx-change-loading",
        ".phx-change-loading &",
      ])
    ),
  ],
};
