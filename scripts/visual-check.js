const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const baseUrl = process.env.EMSILE_URL || 'http://127.0.0.1:8090';
const outputDir = path.join(__dirname, '..', 'docs', 'screenshots');

async function main() {
  fs.mkdirSync(outputDir, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({
    viewport: { width: 390, height: 844 },
    deviceScaleFactor: 2,
    isMobile: true,
    hasTouch: true,
  });

  const problems = [];
  page.on('console', (message) => {
    if (message.type() === 'error') {
      problems.push(`console: ${message.text()}`);
    }
  });
  page.on('pageerror', (error) => {
    problems.push(`pageerror: ${error.message}`);
  });

  await page.goto(baseUrl, { waitUntil: 'networkidle' });
  await page.waitForTimeout(2500);
  await page.screenshot({
    path: path.join(outputDir, '01-home-mobile.png'),
    fullPage: true,
  });

  await page.touchscreen.tap(195, 796);
  await page.waitForTimeout(900);
  await page.touchscreen.tap(165, 148);
  await page.waitForTimeout(900);
  await page.screenshot({
    path: path.join(outputDir, '02-table-mobile.png'),
    fullPage: true,
  });

  await page.touchscreen.tap(275, 796);
  await page.waitForTimeout(900);
  await page.touchscreen.tap(120, 306);
  await page.waitForTimeout(900);
  await page.screenshot({
    path: path.join(outputDir, '03-practice-mobile.png'),
    fullPage: true,
  });

  await browser.close();

  if (problems.length > 0) {
    console.error(problems.join('\n'));
    process.exit(1);
  }

  console.log(`Visual check passed: ${outputDir}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
