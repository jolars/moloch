module.exports = {
  branches: ["main", "next"],
  plugins: [
    [
      "@semantic-release/commit-analyzer",
      {
        preset: "conventionalcommits",
      },
    ],
    [
      "@semantic-release/release-notes-generator",
      {
        preset: "conventionalcommits",
      },
    ],
    [
      "@semantic-release/changelog",
      {
        changelogTitle: "# Changelog",
      },
    ],
    [
      "semantic-release-replace-plugin",
      {
        replacements: [
          {
            files: ["doc/moloch.tex"],
            from: "\\\\def\\\\molochversion\\{([0-9]+\\.[0-9]+\\.[0-9]+)\\}",
            to: "\\def\\molochversion{${nextRelease.version}}",
            results: [
              {
                file: "doc/moloch.tex",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
            ],
            countMatches: true,
          },
          {
            files: ["build.lua"],
            from: 'version = "([0-9]+\\.[0-9]+\\.[0-9]+)"',
            to: 'version = "${nextRelease.version}"',
            results: [
              {
                file: "build.lua",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
            ],
            countMatches: true,
          },
          {
            files: [
              "src/beamercolorthememoloch-highcontrast.dtx",
              "src/beamercolorthememoloch-tomorrow.dtx",
              "src/beamercolorthememoloch.dtx",
              "src/beamerfontthememoloch.dtx",
              "src/beamerinnerthememoloch.dtx",
              "src/beamerouterthememoloch.dtx",
              "src/beamerthememoloch.dtx",
            ],
            from: /\\ProvidesPackage\{([^\}]+)\}\[\d{4}-\d{2}-\d{2} v([0-9]+\.[0-9]+\.[0-9]+) ([^\]]+)\]/g,
            to: (_match, pkg, _version, desc, ...args) => {
              const context = args[args.length - 1];
              const { execSync } = require("child_process");
              const date = execSync(
                `git show -s --format=%cs ${context.nextRelease.gitHead}`,
              )
                .toString()
                .trim();
              return `\\ProvidesPackage{${pkg}}[${date} v${context.nextRelease.version} ${desc}]`;
            },
            results: [
              {
                file: "src/beamercolorthememoloch-highcontrast.dtx",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
              {
                file: "src/beamercolorthememoloch-tomorrow.dtx",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
              {
                file: "src/beamercolorthememoloch.dtx",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
              {
                file: "src/beamerfontthememoloch.dtx",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
              {
                file: "src/beamerinnerthememoloch.dtx",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
              {
                file: "src/beamerouterthememoloch.dtx",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
              {
                file: "src/beamerthememoloch.dtx",
                hasChanged: true,
                numMatches: 1,
                numReplacements: 1,
              },
            ],
            countMatches: true,
          },
        ],
      },
    ],
    [
      "@semantic-release/git",
      {
        message:
          "chore(release): release ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}",
        assets: [
          "src/beamercolorthememoloch-highcontrast.dtx",
          "src/beamercolorthememoloch-tomorrow.dtx",
          "src/beamercolorthememoloch.dtx",
          "src/beamerfontthememoloch.dtx",
          "src/beamerinnerthememoloch.dtx",
          "src/beamerouterthememoloch.dtx",
          "src/beamerthememoloch.dtx",
          "doc/moloch.tex",
          "build.lua",
          "CHANGELOG.md",
        ],
      },
    ],
    "@semantic-release/github",
  ],
};
