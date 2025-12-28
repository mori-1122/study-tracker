// tailwind.config.js
export default {
  content: [
    "./app/views/**/*.{html,erb}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  safelist: [
    "bg-gray-800",
    "border-gray-200",
    "text-gray-200",
    "hover:text-white",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
