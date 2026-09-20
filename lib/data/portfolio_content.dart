import 'models/portfolio.dart';

/// Sample content from the design references. Replace these values with your
/// own information before publishing. No personal accounts are assumed.
abstract final class PortfolioContent {
  static const profile = PortfolioProfile(
    name: 'Yorn Nona',
    initials: 'AC',
    avatarAsset: 'assets/profile_photo.jpg',
    role: 'Senior Flutter Engineer',
    tagline:
        'Building fluid, native-feeling apps for\niOS & Android — one widget at a time.',
    bio:
        "I'm a mobile engineer who specialises in Flutter — turning product ideas into smooth, accessible, production-ready apps. I care about clean architecture, thoughtful motion, and shipping fast without cutting corners.",
    email: 'yornnonaistad@gmail.com',
    phone: '+855 (096) 80 93 758',
    location: 'Phnom Penh, Cambodia',
    languages: 'Khmer & English',
    experienceSummary: '1+ years writing production Dart',
    availability:
        'Available for freelance projects and full-time roles. Let’s turn your next idea into something people love.',
    stats: [
      PortfolioStat('4+', 'Years'),
      PortfolioStat('22', 'Apps shipped'),
      PortfolioStat('1.8M', 'Installs'),
    ],
    education: Education(
      degree: 'SoftWare Development',
      school: 'Norton University',
      period: '2019 – 2023',
    ),
    values: [
      'Clean Architecture',
      'Accessibility',
      'Performance',
      'Design detail',
    ],
    // Add your profile URLs to enable the social buttons.
    socials: [
      SocialProfile(SocialPlatform.github, 'GitHub'),
      SocialProfile(SocialPlatform.linkedIn, 'LinkedIn'),
      SocialProfile(SocialPlatform.x, 'X'),
      SocialProfile(SocialPlatform.dribbble, 'Dribbble'),
    ],
  );

  static const projects = [
    PortfolioProject(
      id: 'piisiit-note',
      name: 'Piisiit Note',
      summary: 'Offline-first note-taking, built in Flutter.',
      description:
          'Offline-first note-taking with tag-based organization. A quiet space to capture ideas, collect inspiration, and find your thoughts again.',
      status: '12K+ downloads',
      category: ProjectCategory.productivity,
      technologies: ['Flutter', 'Riverpod', 'Hive'],
      features: [
        'Capture and edit notes, even without a connection.',
        'Organize ideas with flexible tags and instant search.',
        'A focused, accessible interface with a thoughtful dark mode.',
      ],
      artwork: ProjectArtwork.notes,
    ),
    PortfolioProject(
      id: 'taskflow',
      name: 'TaskFlow',
      summary: 'A little less busywork. A lot more flow.',
      description:
          'Task & project management with real-time collaboration. Designed to help small teams stay in sync and make room for their best work.',
      status: 'In development',
      category: ProjectCategory.clientWork,
      technologies: ['Flutter', 'Firebase', 'GraphQL'],
      features: [
        'Keep projects moving with shared task boards.',
        'Stay up to date with real-time team collaboration.',
        'Make priorities clear with a simple, considered workflow.',
      ],
      artwork: ProjectArtwork.tasks,
    ),
  ];

  static const skills = [
    PortfolioSkill('Dart', .95, SkillTone.mint),
    PortfolioSkill('Flutter', .95, SkillTone.violet),
    PortfolioSkill('Firebase', .80, SkillTone.coral),
    PortfolioSkill('Riverpod', .88, SkillTone.sky),
  ];

  static const otherSkills = [
    'MVVM',
    'BLoC',
    'Git',
    'CI/CD',
    'REST & GraphQL',
    'Unit Testing',
    'Swift',
    'Kotlin',
    'Figma',
  ];

  static const experience = [
    WorkExperience(
      role: 'Senior Flutter Engineer',
      company: 'Nimbus Labs',
      period: '2023 — Present',
      description:
          'Leading the mobile team on a fintech app used by 500K+ people; improved the crash-free rate to 99.8%.',
      technologies: ['Flutter', 'Riverpod', 'CI/CD'],
      current: true,
    ),
    WorkExperience(
      role: 'Flutter Developer',
      company: 'Pixel Forge Studio',
      period: '2021 — 2023',
      description:
          'Shipped 12 client apps from concept to App Store, averaging a 4.8★ rating.',
      technologies: ['Dart', 'Firebase', 'BLoC'],
    ),
    WorkExperience(
      role: 'Mobile Engineering Intern',
      company: 'AppWorks',
      period: '2020 — 2021',
      description:
          "Built internal tooling and contributed to the company's first Flutter release.",
      technologies: ['Flutter', 'Git'],
    ),
  ];
}
