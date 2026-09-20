enum ProjectCategory {
  all('All'),
  productivity('Productivity'),
  clientWork('Client work'),
  openSource('Open source');

  const ProjectCategory(this.label);
  final String label;
}

enum ProjectArtwork { notes, tasks }

enum SkillTone { mint, violet, coral, sky }

enum SocialPlatform { github, linkedIn, x, dribbble }

class PortfolioProfile {
  const PortfolioProfile({
    required this.name,
    required this.initials,
    required this.role,
    required this.tagline,
    required this.bio,
    required this.email,
    required this.phone,
    required this.location,
    required this.languages,
    required this.experienceSummary,
    required this.availability,
    required this.stats,
    required this.education,
    required this.values,
    required this.socials,
    this.avatarAsset,
    this.available = true,
  });

  final String name;
  final String initials;
  final String role;
  final String tagline;
  final String bio;
  final String email;
  final String phone;
  final String location;
  final String languages;
  final String experienceSummary;
  final String availability;
  final bool available;
  final List<PortfolioStat> stats;
  final Education education;
  final List<String> values;
  final List<SocialProfile> socials;
  final String? avatarAsset;
}

class PortfolioStat {
  const PortfolioStat(this.value, this.label);
  final String value;
  final String label;
}

class Education {
  const Education({
    required this.degree,
    required this.school,
    required this.period,
  });
  final String degree;
  final String school;
  final String period;
}

class SocialProfile {
  const SocialProfile(this.platform, this.label, {this.url});
  final SocialPlatform platform;
  final String label;
  final String? url;
}

class PortfolioProject {
  const PortfolioProject({
    required this.id,
    required this.name,
    required this.summary,
    required this.description,
    required this.status,
    required this.category,
    required this.technologies,
    required this.features,
    required this.artwork,
    this.url,
  });

  final String id;
  final String name;
  final String summary;
  final String description;
  final String status;
  final ProjectCategory category;
  final List<String> technologies;
  final List<String> features;
  final ProjectArtwork artwork;
  final String? url;
}

class PortfolioSkill {
  const PortfolioSkill(this.name, this.proficiency, this.tone);
  final String name;
  final double proficiency;
  final SkillTone tone;
}

class WorkExperience {
  const WorkExperience({
    required this.role,
    required this.company,
    required this.period,
    required this.description,
    required this.technologies,
    this.current = false,
  });

  final String role;
  final String company;
  final String period;
  final String description;
  final List<String> technologies;
  final bool current;
}
