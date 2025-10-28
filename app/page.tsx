export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="text-center">
        <h1 className="text-4xl font-bold mb-4">Frontend Test</h1>
        <p className="text-xl text-gray-600 mb-8">
          Clean Next.js ISR setup on Cloudflare Pages
        </p>
        <nav className="space-y-2">
          <p>
            <a
              href="/isr-test"
              className="text-blue-600 hover:text-blue-800 underline text-lg"
            >
              ISR Test Page
            </a>
          </p>
        </nav>
      </div>
    </main>
  );
}
