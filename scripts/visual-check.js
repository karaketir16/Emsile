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

  // 2. Dersler Ekranı
  await tap(page, 117, navigationBarY);
  await page.screenshot({
    path: path.join(outputDir, '05-lessons-mobile.png'),
    fullPage: true,
  });

  // 3. Ders Detay Ekranı
  await tap(page, 165, 154);
  await page.screenshot({
    path: path.join(outputDir, '06-lesson-detail-mobile.png'),
    fullPage: true,
  });
  await tap(page, 28, 28); // Geri dön

  // 4. Tablo Ekranı
  await tap(page, 195, navigationBarY);
  await tap(page, 165, 154);
  await page.screenshot({
    path: path.join(outputDir, '02-table-mobile.png'),
    fullPage: true,
  });

  // 5. Zamirler Ekranı
  await tap(page, 28, 28); // Geri dön
  await tap(page, 165, 230);
  await page.screenshot({
    path: path.join(outputDir, '04-pronouns-mobile.png'),
    fullPage: true,
  });
  await tap(page, 28, 28); // Geri dön

  // 6. Pratik Ekranı
  await tap(page, 275, navigationBarY);
  await page.screenshot({
    path: path.join(outputDir, '07-practice-modes-mobile.png'),
    fullPage: true,
  });

  // 7. Eşleştirme Alıştırması
  await tap(page, 165, 154);
  await page.screenshot({
    path: path.join(outputDir, '08-matching-practice-mobile.png'),
    fullPage: true,
  });
  await tap(page, 28, 28); // Geri dön

  // 8. Çoktan Seçmeli
  await tap(page, 165, 285);
  await page.screenshot({
    path: path.join(outputDir, '03-practice-mobile.png'),
    fullPage: true,
  });
  await tap(page, 28, 28); // Geri dön

  // 9. Tabloyu Doldur
  await tap(page, 165, 415);
  await page.screenshot({
    path: path.join(outputDir, '09-table-fill-practice-mobile.png'),
    fullPage: true,
  });
  await tap(page, 28, 28); // Geri dön

  // 10. Hakkında Ekranı
  await tap(page, 351, navigationBarY);
  await page.screenshot({
    path: path.join(outputDir, '10-about-mobile.png'),
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
