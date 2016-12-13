export const homeScore = (match) => match.map('.home_score').skipDuplicates()
export const awayScore = (match) => match.map('.away_score').skipDuplicates()

export const homeName = (match) => match.map('.home_player.name').skipDuplicates()
export const awayName = (match) => match.map('.away_player.name').skipDuplicates()

export const homePortrait = (match) => match.map('.home_player.portrait_url').skipDuplicates()
export const awayPortrait = (match) => match.map('.away_player.portrait_url').skipDuplicates()

export const homeService = (match) => match.map('.home_service').skipDuplicates()
export const awayService = (match) => match.map('.away_service').skipDuplicates()
