#!/usr/bin/env php
<?php declare(strict_types=1);

namespace Platformsh\Scripts;

$cliCommand = 'platform';

log("Fetching the list of regions from the API...");

$json = run($cliCommand . ' api:curl /regions');
$regions = $json ? \json_decode($json, true) : [];
if (!$regions || empty($regions['regions'])) {
  log("\nUnable to read regions from the API.");
  exit(1);
}

// Remove private regions.
$regions['regions'] = \array_filter($regions['regions'], function($data) { return empty($data['private']); });

log(\count($regions['regions']) . " region(s) found\n");

$hostnames = [];
foreach ($regions['regions'] as $region) {
  $hostname = \parse_url($region['endpoint'], PHP_URL_HOST);
  if (!$hostname) {
    log("Failed to parse hostname for region: " . $region['id']);
    continue;
  }
  $hostnames[] = $hostname;
}

\sort($hostnames);

$known_hosts = [];

$prefixes = ['git.', 'ssh.'];
$count = \count($hostnames) * \count($prefixes);
$i = 1;
foreach ($hostnames as $hostname) {
  foreach ($prefixes as $prefix) {
    log(\sprintf("%02d/%02d Scanning %s%s", $i, $count, $prefix, $hostname));
    if ($output = run('ssh-keyscan ' . \escapeshellarg($prefix . $hostname) . ' 2>/dev/null')) {
      $known_hosts[] = trim($output);
    }
    $i++;
  }
}

$filename = __DIR__ . '/known_hosts';

if (!\file_put_contents($filename, \implode("\n", $known_hosts) . "\n")) {
  log("Failed to write to file: $filename");
  exit(1);
}

log("\nDone. Review any change(s) carefully.");
exit(0);

function log(string $msg, $newline = true): void {
  \fputs(STDERR, $msg . ($newline ? "\n" : ''));
}

function run(string $cmd): string {
  \exec($cmd, $output, $result_code);
  if ($result_code !== 0) {
    log("The command returned an error code ($result_code): $cmd");
    return '';
  }
  return \implode("\n", $output);
}
