#!/usr/bin/env php
<?php
declare(strict_types=1);

$manifestUrl = 'https://raw.githubusercontent.com/platformsh/legacy-cli/main/dist/manifest.json';
$installScriptFilename = __DIR__ . '/install-cli.sh';

$manifest = json_decode(file_get_contents($manifestUrl), true);
if ($manifest === null) {
    throw new \RuntimeException("Failed to decode manifest: $manifestUrl");
}

$latest = get_latest_version($manifest);
if (empty($latest)) {
    throw new \RuntimeException('Failed to find a latest version in manifest.');
}

$installScript = file_get_contents($installScriptFilename);
if (!$installScript) {
    throw new \RuntimeException("Failed to read file: $installScriptFilename");
}

$newContents = update_script($installScript, $latest['version'], $latest['sha256']);

if ($newContents === $installScript) {
    echo "Nothing to update\n";
    exit;
}
$success = file_put_contents($installScriptFilename, $newContents) !== false;
if (!$success) {
    throw new \RuntimeException("Failed to update file: $installScriptFilename");
}
echo "Updated file: $installScriptFilename\n";

echo "Committing to Git...\n";
passthru('git add ' . escapeshellarg($installScriptFilename), $return_var);
if ($return_var !== 0) {
    exit($return_var);
}
passthru('git commit -m ' . escapeshellarg("Update CLI to " . $latest['version']), $return_var);
if ($return_var !== 0) {
    exit($return_var);
}
echo "Pushing...\n";
passthru('git push', $return_var);
exit($return_var);

function update_script(string $script, string $version, string $sha256): string
{
    $script = preg_replace('/^version=([0-9.-z\-"\']*)/m', 'version="' . ltrim($version, 'v') . '"', $script);
    $script = preg_replace('/^sha256=([0-9.a-z\-"\']*)/m', 'sha256="' . $sha256 . '"', $script);

    return $script;
}

function get_latest_version(array $manifest): ?array
{
    $sorted = $manifest;
    $sorted = array_filter($sorted, function (array $item) {
        return strpos($item['version'], '-') === false;
    });
    usort($sorted, function (array $a, array $b) {
        return version_compare($b['version'], $a['version']);
    });

    return reset($sorted) ?: null;
}
