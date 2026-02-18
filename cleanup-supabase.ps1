# Script to remove all Supabase-related code and files

Write-Host "Cleaning up Supabase code..." -ForegroundColor Green

# Remove Supabase-related files
$filesToRemove = @(
    "js\comments-secure.js",
    "netlify\functions\comments\comments.js",
    "netlify\functions\comments",
    "netlify\functions",
    "netlify.toml",
    "api\comments.js",
    "api",
    "fix-security.ps1",
    "SECURITY_FIX_README.md"
)

foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        try {
            Remove-Item -Path $file -Recurse -Force
            Write-Host "Removed: $file" -ForegroundColor Green
        } catch {
            Write-Host "Error removing $file`: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "Not found: $file" -ForegroundColor Yellow
    }
}

# Remove comment sections from HTML files
$postFiles = Get-ChildItem -Path "posts\*.html" -Recurse
$updatedCount = 0

foreach ($file in $postFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw
        
        # Remove the entire comments section
        $commentSectionPattern = '(?s)<section id="comments">.*?</section>.*?<script src="/js/comments-secure\.js"></script>'
        
        if ($content -match $commentSectionPattern) {
            $newContent = $content -replace $commentSectionPattern, ''
            Set-Content -Path $file.FullName -Value $newContent -NoNewline
            Write-Host "Cleaned comments from: $($file.Name)" -ForegroundColor Green
            $updatedCount++
        } else {
            Write-Host "No comments section found in: $($file.Name)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error cleaning $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nCleanup complete!" -ForegroundColor Green
Write-Host "Files cleaned: $updatedCount" -ForegroundColor Cyan
Write-Host "Ready for Giscus setup!" -ForegroundColor Yellow
