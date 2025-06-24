export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // ✨ nova funcionalidade
        'fix',      // 🐛 correção de bug
        'docs',     // 📚 documentação
        'style',    // 💎 formatação, missing semi colons, etc; no code change
        'refactor', // 📦 refatoração de código que não corrige bug nem adiciona feature
        'perf',     // 🚀 mudança de código que melhora performance
        'test',     // 🚨 adicionando testes
        'chore',    // 🔧 mudanças de build ou ferramentas auxiliares
        'revert',   // ⏪ reverte commit anterior
        'build',    // 📦 mudanças que afetam o build system
        'ci',       // 👷 mudanças de CI
      ],
    ],
    'subject-case': [2, 'never', ['sentence-case', 'start-case', 'pascal-case', 'upper-case']],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'type-case': [2, 'always', 'lower-case'],
    'type-empty': [2, 'never'],
  },
}; 