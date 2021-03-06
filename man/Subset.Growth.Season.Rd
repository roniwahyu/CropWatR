\name{Subset.Growth.Season}
\alias{Subset.Growth.Season}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Subset.Growth.Season(RowCrop, energycrops = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{RowCrop}{
%%     ~~Describe \code{RowCrop} here~~
}
  \item{energycrops}{
%%     ~~Describe \code{energycrops} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (RowCrop, energycrops = FALSE) 
{
    Growth_stages <- read.csv("Growth_stages.csv")
    Growth_stages$Region <- as.character(Growth_stages$Region)
    Kcb <- read.csv("Kcb_values.csv")
    Lat.long <- read.csv("lat.long.vals.csv")
    TopSoil <- read.csv("TopSoil.csv")
    CROP <- RowCrop
    if (RowCrop == "fall_oats" | RowCrop == "spring_oats") 
        CROP <- "oats"
    if (RowCrop == "spring_barley" | RowCrop == "fall_barley") 
        CROP <- "barley"
    if (RowCrop == "silage" || RowCrop == "corn") 
        CROP <- "corn"
    Base.2008.CDL <- read.csv("CDL.main.crops.2008.base.csv")
    load("Vars.RData")
    Rm.Vars <- Vars[-grep(CROP, Vars)]
    Base.CDL.crop <- Base.2008.CDL[, c(!(names(Base.2008.CDL) \%in\% 
        Rm.Vars))]
    PH <- read.csv("Planting_harvesting_dates_final.csv")
    PH <- subset(PH, Crop == RowCrop, select = c(2, 13:15, 17), 
        drop = TRUE)
    Stages <- Growth_stages[grep(CROP, Growth_stages$Crop), ]
    if (RowCrop == "spring_wheat" | RowCrop == "spring_barley" | 
        RowCrop == "spring_oats" | RowCrop == "durum_wheat") {
        Stages <- Growth_stages[Growth_stages$Crop == "barley_oats_wheat", 
            ]
        PH <- cbind(PH, Stages[Stages$Plant_Date == "November", 
            ])
    }
    if (RowCrop == "fall_barley" | RowCrop == "fall_oats") {
        Stages <- Growth_stages[Growth_stages$Crop == "barley_oats_wheat_fall", 
            ]
        PH <- cbind(PH, Stages[Stages$Plant_Date == "Nov", ])
    }
    if (RowCrop == "winter_wheat") {
        PH1 <- cbind(PH[(PH$Growing_Season <= 270), ], Stages[Stages$Plant_Date == 
            "December", ])
        PH2 <- cbind(PH[(PH$Growing_Season > 270), ], Stages[Stages$Plant_Date == 
            "October", ])
        PH <- rbind(PH1, PH2)
    }
    if (RowCrop == "sugarcane") {
        PH <- cbind(PH, Stages[Stages$Crop == "sugarcane_ratoon", 
            ])
    }
    if (RowCrop == "sugarbeets") {
        PH <- cbind(PH, Stages[Stages$Region == "ID", ])
    }
    if (RowCrop == "alfalfa") {
        PH1 <- cbind(PH[(PH$Growing_Season <= 290), ], Stages[(Stages$Crop == 
            "alfalfa_1st_cutting_cycle") & (Stages$Region == 
            "CA"), ])
        PH2 <- cbind(PH[(PH$Growing_Season > 290), ], Stages[(Stages$Crop == 
            "alfalfa_1st_cutting_cycle") & (Stages$Region == 
            "ID"), ])
        PH <- rbind(PH1, PH2)
    }
    if (RowCrop == "corn" | RowCrop == "silage") {
        PH1 <- cbind(PH[(PH$Growing_Season <= 146), ], Stages[(Stages$Total == 
            140), ])
        PH2 <- cbind(PH[((PH$Growing_Season > 146) & (PH$Growing_Season <= 
            155)), ], Stages[(Stages$Total == 155), ])
        PH3 <- cbind(PH[(PH$Growing_Season > 155), ], Stages[(Stages$Total == 
            170), ])
        PH <- rbind(PH1, PH2, PH3)
    }
    if (RowCrop == "cotton") {
        PH1 <- cbind(PH[(PH$Growing_Season <= 180), ], Stages[(Stages$Total == 
            180), ])
        PH2 <- cbind(PH[(PH$Growing_Season > 180), ], Stages[(Stages$Total == 
            225), ])
        PH <- rbind(PH1, PH2)
    }
    if (RowCrop == "sorghum") {
        PH1 <- cbind(PH[(PH$State_Fips == 4 | PH$State_Fips == 
            35 | PH$State_Fips == 48), ], Stages[(Stages$Total == 
            130), ])
        PH2 <- cbind(PH[(PH$State_Fips != 4 & PH$State_Fips != 
            35 & PH$State_Fips != 48), ], Stages[(Stages$Total == 
            125), ])
        PH <- rbind(PH1, PH2)
    }
    if (RowCrop == "idle_cropland" | RowCrop == "pasture_grass" | 
        RowCrop == "rep_cropland") {
        PH <- cbind(PH, Stages)
    }
    if (RowCrop == "rice" | RowCrop == "soybeans" | RowCrop == 
        "peanuts" | RowCrop == "miscanthus" | RowCrop == "switchgrass") {
        PH <- cbind(PH, Stages)
    }
    print("on to split seasons functions")
    if (file.exists(paste0(Intermediates, paste("Base", RowCrop, 
        "MNRH_", "MasterDF", sep = "."))) == FALSE) {
        E.Precip_Seasons <- Split.Seasons(RowCrop, "Precip_", 
            Lat.long, TopSoil, Base.CDL.crop, PH)
        ETo.Seasons <- Split.Seasons(RowCrop, "ETo_", Lat.long, 
            TopSoil, Base.CDL.crop, PH)
        U2.Seasons <- Split.Seasons(RowCrop, "U2.final_", Lat.long, 
            TopSoil, Base.CDL.crop, PH)
        MNRH.Seasons <- Split.Seasons(RowCrop, "MNRH_", Lat.long, 
            TopSoil, Base.CDL.crop, PH)
    }
    if (file.exists(paste0(Intermediates, paste("Base", RowCrop, 
        "MNRH_", "MasterDF", sep = ".")))) {
        load(paste0(Intermediates, paste("Base", RowCrop, "Precip_", 
            "MasterDF", sep = ".")))
        E.Precip_Seasons <- DF
        load(paste0(Intermediates, paste("Base", RowCrop, "ETo_", 
            "MasterDF", sep = ".")))
        ETo.Seasons <- DF
        load(paste0(Intermediates, paste("Base", RowCrop, "U2.final_", 
            "MasterDF", sep = ".")))
        U2.Seasons <- DF
        load(paste0(Intermediates, paste("Base", RowCrop, "MNRH_", 
            "MasterDF", sep = ".")))
        MNRH.Seasons <- DF
        rm(DF)
    }
    if (RowCrop == "cotton" | RowCrop == "rice" | RowCrop == 
        "soybeans" | RowCrop == "peanuts" | RowCrop == "alfalfa" | 
        RowCrop == "sugarcane" | RowCrop == "spring_wheat" | 
        RowCrop == "miscanthus" | RowCrop == "switchgrass" | 
        RowCrop == "idle_cropland" | RowCrop == "pasture_grass" | 
        RowCrop == "rep_cropland") {
        Kcb <- Kcb[grep(RowCrop, Kcb$Crop), ]
    }
    if (RowCrop == "durum_wheat") 
        Kcb <- Kcb[Kcb$Crop == "spring_wheat", ]
    if (RowCrop == "fall_oats") 
        Kcb <- Kcb[Kcb$Crop == "oats", ]
    if (RowCrop == "spring_oats") 
        Kcb <- Kcb[Kcb$Crop == "spring_oats", ]
    if (RowCrop == "fall_barley") 
        Kcb <- Kcb[Kcb$Crop == "barley", ]
    if (RowCrop == "spring_barley") 
        Kcb <- Kcb[Kcb$Crop == "spring_barley", ]
    if (RowCrop == "corn" | RowCrop == "silage") 
        Kcb <- Kcb[Kcb$Crop == "corn_field_harvest_high_grain_moisture", 
            ]
    if (RowCrop == "winter_wheat") 
        Kcb <- Kcb[Kcb$Crop == "winter_wheat_unfrozen", ]
    if (RowCrop == "sorghum") 
        Kcb <- Kcb[Kcb$Crop == "sorghum_grain", ]
    if (RowCrop == "sugarbeets") 
        Kcb <- Kcb[Kcb$Crop == "sugarbeets_rainfed_or_dry_end", 
            ]
    print("on to Rescale.And.Save")
    Rescale.And.Save("Precip_", PH, E.Precip_Seasons, RowCrop, 
        Kcb)
    Rescale.And.Save("ETo_", PH, ETo.Seasons, RowCrop, Kcb)
    Rescale.And.Save("U2.final_", PH, U2.Seasons, RowCrop, Kcb)
    Rescale.And.Save("MNRH_", PH, MNRH.Seasons, RowCrop, Kcb)
    Save.Crops.List(PH, RowCrop, Kcb)
    if (file.exists(paste0(Intermediates, paste("Base", RowCrop, 
        "MNRH_", "MasterDF", sep = "."))) == FALSE) {
        print(paste("Crops List file already saved for", RowCrop))
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
