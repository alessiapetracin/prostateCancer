### prostateCancer ###

---

### Introduction ###

The analysis focuses on cancer data, to investigate the association between the level of prostate specific antigen and a number of clinical measures, measured in 97 men who were about to receive a radical prostatectomy.

The dataset used for the analysis measures the level of the antigen "lpsa" and a number of clinical measures:
-  lcavol: log(cancer volume in cm3)
-  lweight: log(prostate weight in g)
-  age in years
-  lbph: log(amount of benign prostatic hyperplasia in cm2)
-  svi: seminal vesicle invasion (1 = yes, 0 = no)
-  lcp: log(capsular penetration in cm)
-  gleason: Gleason score for prostate cancer (6,7,8,9)
-  pgg45: percentage of Gleason scores 4 or 5, recorded over their visit history before their final current Gleason score

In order to analyze the relation between the "lpsa" level and the other variables, a number of models is used:
- Decision tree
- Random forest
- Boosted regression tree

The three methods are then compared to evaluate the one that yields better predictions for the task at hand.

---

