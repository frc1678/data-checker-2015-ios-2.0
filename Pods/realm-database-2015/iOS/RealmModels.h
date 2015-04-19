#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class TeamInMatchData;
@class Team;
@class CalculatedTeamData;
@class UploadedTeamData;
@class Match;
@class CalculatedMatchData;
@class UploadedTeamInMatchData;
@class CoopAction;
@class ReconAcquisition;
@class CalculatedTeamInMatchData;
@class CalculatedCompetitionData;
@class Competition;

RLM_ARRAY_TYPE(TeamInMatchData)
RLM_ARRAY_TYPE(Team)
RLM_ARRAY_TYPE(CalculatedTeamData)
RLM_ARRAY_TYPE(UploadedTeamData)
RLM_ARRAY_TYPE(Match)
RLM_ARRAY_TYPE(CalculatedMatchData)
RLM_ARRAY_TYPE(UploadedTeamInMatchData)
RLM_ARRAY_TYPE(CoopAction)
RLM_ARRAY_TYPE(ReconAcquisition)
RLM_ARRAY_TYPE(CalculatedTeamInMatchData)
RLM_ARRAY_TYPE(CalculatedCompetitionData)
RLM_ARRAY_TYPE(Competition)


@interface TeamInMatchData : RLMObject

@property Team *team;
@property Match *match;
@property UploadedTeamInMatchData *uploadedData;
@property CalculatedTeamInMatchData *calculatedData;

@end


@interface Team : RLMObject

@property NSInteger number;
@property NSString *name;
@property NSInteger seed;
@property RLMArray<TeamInMatchData> *matchData;
@property CalculatedTeamData *calculatedData;
@property UploadedTeamData *uploadedData;

@end


@interface CalculatedTeamData : RLMObject

@property NSInteger predictedSeed;
@property NSInteger totalScore;
@property float averageScore;
@property float predictedTotalScore;
@property float predictedAverageScore;
@property float firstPickAbility;
@property float secondPickAbility;
@property float thirdPickAbilityLandfill;
@property float thirdPickAbility;
@property float stackingAbility;
@property float noodleReliability;
@property float avgNumMaxHeightStacks;
@property float reconAbility;
@property float reconReliability;
@property float isRobotMoveIntoAutoZonePercentage;
@property float isStackedToteSetPercentage;
@property float avgNumReconsMovedIntoAutoZone;
@property float avgNumTotesStacked;
@property float avgNumReconLevels;
@property float avgNumNoodlesContributed;
@property float avgNumReconsStacked;
@property float avgNumTotesPickedUpFromGround;
@property float avgNumLitterDropped;
@property float avgNumStacksDamaged;
@property float avgMaxFieldToteHeight;
@property float avgMaxReconHeight;
@property float avgAgility;
@property float driverAbility;
@property float avgStackPlacing;
@property float avgHumanPlayerLoading;
@property float incapacitatedPercentage;
@property float disabledPercentage;
@property float reliability;
@property NSString *reconAcquisitionTypes;
@property NSString *mostCommonReconAcquisitionType;
@property float avgCoopPoints;
@property float stepReconSuccessRateInAuto;
@property float avgStepReconsAcquiredInAuto;
@property float bottomPlacingSuccessRate;
@property float avgNumHorizontalReconsPickedUp;
@property float avgNumVerticalReconsPickedUp;
@property float avgNumReconsPickedUp;
@property float avgNumCappedSixStacks;
@property float avgNumTotesFromHP;
@property float avgNumTeleopReconsFromStep;

@end


@interface UploadedTeamData : RLMObject

@property NSString *pitOrganization;
@property NSString *programmingLanguage;
@property NSString *pitNotes;
@property BOOL canMountMechanism;
@property BOOL willingToMount;
@property float easeOfMounting;

@end


@interface Match : RLMObject

@property NSString *match;
@property RLMArray<Team> *redTeams;
@property RLMArray<Team> *blueTeams;
@property RLMArray<TeamInMatchData> *teamInMatchDatas;
@property NSInteger officialRedScore;
@property NSInteger officialBlueScore;
@property CalculatedMatchData *calculatedData;

@end


@interface CalculatedMatchData : RLMObject

@property NSInteger predictedRedScore;
@property NSInteger predictedBlueScore;
@property NSString *bestRedAutoStrategy;
@property NSString *bestBlueAutoStrategy;

@end


@interface UploadedTeamInMatchData : RLMObject

@property BOOL stackedToteSet;
@property NSInteger numContainersMovedIntoAutoZone;
@property NSInteger numTotesStacked;
@property NSInteger numReconLevels;
@property NSInteger numNoodlesContributed;
@property NSInteger numReconsStacked;
@property NSInteger numHorizontalReconsPickedUp;
@property NSInteger numVerticalReconsPickedUp;
@property NSInteger numTotesPickedUpFromGround;
@property NSInteger numLitterDropped;
@property NSInteger numStacksDamaged;
@property RLMArray<CoopAction> *coopActions;
@property NSInteger maxFieldToteHeight;
@property NSInteger maxReconHeight;
@property NSInteger numTeleopReconsFromStep;
@property NSInteger numTotesFromHP;
@property RLMArray<ReconAcquisition> *reconAcquisitions;
@property NSInteger agility;
@property NSInteger stackPlacing;
@property NSInteger humanPlayerLoading;
@property BOOL incapacitated;
@property BOOL disabled;
@property NSString *miscellaneousNotes;
@property NSInteger numStepReconAcquisitionsFailed;
@property NSInteger numSixStacksCapped;

@end


@interface CoopAction : RLMObject

@property NSInteger uniqueID;
@property NSInteger numTotes;
@property BOOL onTop;
@property BOOL didSucceed;

@end


@interface ReconAcquisition : RLMObject

@property NSInteger uniqueID;
@property NSInteger numReconsAcquired;
@property BOOL acquiredMiddle;

@end


@interface CalculatedTeamInMatchData : RLMObject

@property NSInteger numReconsPickedUp;

@end


@interface CalculatedCompetitionData : RLMObject

@property NSInteger cachedData;

@end


@interface Competition : RLMObject

@property NSString *name;
@property NSString *competitionCode;
@property RLMArray<Match> *matches;
@property RLMArray<Team> *attendingTeams;
@property CalculatedCompetitionData *calculatedData;

@end


