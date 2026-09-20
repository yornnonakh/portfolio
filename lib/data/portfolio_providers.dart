import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'portfolio_content.dart';

final profileProvider = Provider((ref) => PortfolioContent.profile);
final projectsProvider = Provider((ref) => PortfolioContent.projects);
final skillsProvider = Provider((ref) => PortfolioContent.skills);
final otherSkillsProvider = Provider((ref) => PortfolioContent.otherSkills);
final experienceProvider = Provider((ref) => PortfolioContent.experience);
