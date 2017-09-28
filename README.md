# CMAPAnalysis
An Igor Pro procedure with GUI used for averaging, analyses, figure preparation of evoked potentials. The parameters for analysis are latency, duration, amplitude, rectified area, and conduction velocity of the averaged evoked potentials. These parameters are stored on a table and can be exported as a csv file.

## Getting Started

### Prerequisites
* IGOR Pro 6 (https://www.wavemetrics.com/)

This code has been tested in Igor Pro version 6.3.7.2. for Windows and supposed to work in Igor Pro 6.1 or later.

### Installing
1. Install Igor Pro 6.1 or later.
2. Put CMAPAnalysis.ipf or shortcut for it into the Igor Procedures folder, which is normally located at My Documents\WaveMetrics\Igor Pro 6 User Files\Igor Procedures.
3. Put CMAPAnalysis Help.ihf or shortcut for it into the Igor Help Files folder, which is normally located at My Documents\WaveMetrics\Igor Pro 6 User Files\Igor Help Files.
4. Restart Igor Pro.

### How to use
1. Click "CMAP_Preparation" in Macro of Menu. GUI control panel CMAPControlPanel will appear. Global variables are stored in root/Packages/CMAP.
2. Display multiple waves you want to analyze into a graph.
3. Specify the graph as the target window by pressing Get button of Target Window group on the control panel
4. Get the list of source waves by Get button in Target Wave group on the control panel.
5. Duplicate the source waves by Duplicate button in Target Wavelist group on the control panel.
6. Subtract the baseline dc shift from each wave by pressing BaseSub button of Target Wavelist group on the control panel.
7. Average the duplicated waves by pressing Average button.
8. Put cursor A and B, at the beginning and ending of the averaged CMAP, respectively.
9. Set the stimulus artifact onset and nerve length parameters in edit boxes on the control panel.
10. Press Run, Print, Edit, and Save buttons and you will have results on the table, history, and edit boxes on the control panel. And have csv files with an windows prompt.
11. You can prepare publish quality average trace graphs by MGraph1-5 buttons.

### Help:
* CMAP_Help of Macro in Menu or find 'CMAPAnalysis' in Topic of the Help Browser.

## DOI
[![DOI](https://zenodo.org/badge/92870255.svg)](https://zenodo.org/badge/latestdoi/92870255)

## Versioning
We use [SemVer](http://semver.org/) for versioning.

## Releases
* Ver 1.0.0, 2017/05/30

## Authors
* **Yuichi Takeuchi PhD** - *Initial work* - [GitHub](https://github.com/yuichi-takeuchi)
* Affiliation: Department of Physiology, University of Szeged, Hungary
* E-mail: yuichi-takeuchi@umin.net

## License
This project is licensed under the MIT License.

## Acknowledgments
* Department of Physiology, Tokyo Women's Medical University, Tokyo, Japan

## References
CMAPAnalysis has been used for the following works:
* Matsumine H, Sasaki R, Takeuchi Y, Miyata M, Yamato M, Okano T, Sakurai H (2014) Vascularized versus Nonvascularized Island Median Nerve Grafts in the Facial Nerve Regeneration and Functional Recovery of Rats for Facial Nerve Reconstruction Study. Journal of reconstructive microsurgery 30:127-136.
*  Matsumine H, Takeuchi Y, Sasaki R, Kazama T, Kano K, Matsumoto T, Sakurai H, Miyata M, Yamato M (2014) Adipocyte-derived and dedifferentiated fat cells promoting facial nerve regeneration in a rat model. Plast Reconstr Surg 134:686-697.
* Sasaki R, Matsumine H, Watanabe Y, Takeuchi Y, Yamato M, Okano T, Miyata M, Ando T (2014) Electrophysiologic and functional evaluations of regenerated facial nerve defects with a tube containing dental pulp cells in rats. Plast Reconstr Surg 134:970-978.
* Matsumine H, Sasaki R, Takeuchi Y, Watanabe Y, Niimi Y, Sakurai H, Miyata M, Yamato M (2014) Unilateral Multiple Facial Nerve Branch Reconstruction Using “End-to-side Loop Graft” Supercharged by Hypoglossal Nerve. Plast Reconstr Surg Glob Open 2:e240.
* Niimi Y, Matsumine H, Takeuchi Y, Sasaki R, Watanabe Y, Yamato M, Miyata M, Sakurai H (2015) Effectively Axonal-supercharged Interpositional Jump-Graft with an Artificial Nerve Conduit for Rat Facial Nerve Paralysis. Plast Reconstr Surg Glob Open 3:e416.
