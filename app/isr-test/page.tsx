import Link from 'next/link';

export const revalidate = 60; // ISR - revalidate every 60 seconds

async function getTestData() {
  const timestamp = new Date().toISOString();

  return {
    timestamp,
    message: 'This page uses ISR (Incremental Static Regeneration)',
    buildTime: new Date().toLocaleString(),
  };
}

export default async function ISRTestPage() {
  const data = await getTestData();

  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="max-w-md w-full bg-gray-50 rounded-lg shadow-md p-8">
        <h1 className="text-3xl font-bold mb-6">ISR Test Page</h1>

        <div className="space-y-4">
          <div className="border-l-4 border-blue-500 pl-4 py-2">
            <p className="text-sm text-gray-600">Generated at:</p>
            <p className="font-mono text-sm">{data.timestamp}</p>
          </div>

          <div className="border-l-4 border-green-500 pl-4 py-2">
            <p className="text-sm text-gray-600">Message:</p>
            <p className="text-base">{data.message}</p>
          </div>

          <div className="border-l-4 border-purple-500 pl-4 py-2">
            <p className="text-sm text-gray-600">Build Time:</p>
            <p className="font-mono text-sm">{data.buildTime}</p>
          </div>
        </div>

        <div className="mt-8 p-4 bg-blue-50 rounded border border-blue-200">
          <p className="text-sm text-blue-800">
            <strong>ISR Info:</strong> This page revalidates every 60 seconds.
            Refresh the page after 60 seconds to see updated content.
          </p>
        </div>

        <div className="mt-6">
          <Link
            href="/"
            className="inline-block bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            Back to Home
          </Link>
        </div>
      </div>
    </main>
  );
}
