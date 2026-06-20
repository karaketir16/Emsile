const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const baseUrl = process.env.EMSILE_URL || 'http://127.0.0.1:8090';
const outputDir = path.join(__dirname, '..', 'docs', 'screenshots');
const navigationBarY = 806;

async function tap(page, x, y, wait = 700) {
  await page.touchscreen.tap(x, y);
  await page.waitForTimeout(wait);
}

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

  await tap(page, 195, navigationBarY);
  await tap(page, 165, 154);
  await page.screenshot({
    path: path.join(outputDir, '02-table-mobile.png'),
    fullPage: true,
  });

  await tap(page, 28, 28);
  await tap(page, 165, 230);
  await page.screenshot({
    path: path.join(outputDir, '04-pronouns-mobile.png'),
    fullPage: true,
  });

  await tap(page, 28, 28);
  await tap(page, 275, navigationBarY);
  await tap(page, 150, 285);
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
