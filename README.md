# FeatureExtraction_LaneBoundary_HandTrace

<!--
The following template is based on:
Best-README-Template
Search for this, and you will find!
>
<!-- PROJECT LOGO -->
<br />
<p align="center">
  <!-- <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

  <h2 align="center"> FeatureExtraction_LaneBoundary_HandTrace
  </h2>

  <pre align="center">
    <img src=".\Images\TestTrack.png" alt="main laps picture" width="960" height="540">
    <!--figcaption>Fig.1 - The typical progression of map generation.</figcaption -->
    <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

  <p align="center">
    The purpose of FeatureExtraction_LaneBoundary_HandTrace is to manually trace and extract lane boundary geometries from a reference map or test track environment in order to generate structured lane marking data for simulation, visualization, and validation purposes. (I think)
    <br />
    <!-- a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/tree/main/Documents">View Demo</a>
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/issues">Report Bug</a>
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/issues">Request Feature</a -->
  </p>
</p>

***

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About the Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="structure">Repo Structure</a>
      <ul>
        <li><a href="#directories">Top-Level Directories</li>
        <li><a href="#dependencies">Dependencies</li>
      </ul>
    </li>
    <li><a href="#lane-marks">Lane Marks</li>
      <ul>
        <li><a href="#yellow-lane-marks"> Yellow Lane Marks</li>
        <ul>
          <li><a href="#solid-single-yellow-lane-mark"> Solid Single Yellow Lane Mark</li>
          <li><a href="#solid-double-yellow-lane-mark"> Solid Double Yellow Lane Mark</li>
          <li><a href="#dashed-single-yellow-lane-mark"> Dashed Single Yellow Lane Mark</li>
          <li><a href="#dashed-double-yellow-lane-mark"> Dashed Double Yellow Lane Mark</li>
          <li><a href="#solid-dashed-double-yellow-lane-mark"> Solid Dashed Double Yellow Lane Mark</li>
        </ul>
        <li><a href="#white-lane-marks"> White Lane Marks</li>
        <ul>
          <li><a href="#solid-single-white-lane-mark"> Solid Single White Lane Mark</li>
          <li><a href="#solid-double-white-lane-mark"> Solid Double White Lane Mark</li>
          <li><a href="#dashed-single-white-lane-mark"> Dashed Single White Lane Mark</li>
          <li><a href="#short-dashed-single-white-lane-mark"> Short Dashed Single White Lane Mark</li>
          <li><a href="#dotted-dashed-white-lane-mark"> Dotted Dashed White Lane Mark</li>
          <li><a href="#dashed-double-white-lane-mark"> Dashed Double White Lane Mark</li>
          <li><a href="#solid-dashed-double-white-lane-mark"> Solid Dashed Double White Lane Mark</li>
          <li><a href="#stop-line-white-lane-mark"> Stop Line White Lane Mark</li>
          <li><a href="#crosswalk-white-lane-mark"> Crosswalk White Lane Mark</li>
        </ul>
      </ul>
    <li><a href="#functions">Functions</li>
      <ul>
        <li><a href="#basic-support-functions">Basic Support Functions</li>
        <ul>
          <li><a href="#fcn_handtrace_template">fcn_HandTrace_TEMPLATE - gives indices of each lap meeting the zone definition</li>
        </ul>
      </ul>
    <li><a href="#usage">Usage</a></li>
     <ul>
     <li><a href="#general-usage">General Usage</li>
     <li><a href="#examples">Examples</li>
     <li><a href="#definition-of-endpoints">Definition of Endpoints</li>
     </ul>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

***

<!-- ABOUT THE PROJECT -->
## About The Project

<!--[![Product Name Screen Shot][product-screenshot]](https://example.com)-->

The most common location of our testing is the Larson Test Track, and we regularly use “laps around the track” as replicates, hence the name of the library. And when not on the test track and on public roads, data often needs to be segmented from one keypoint to another. For example, it is a common task to seek a subset of path data that resides only from one intersection to the next. While one could segment this data during data collection by simply stopping the vehicle recordings at each segment, it is impractical and dangerous to stop data collection at each and every possible intersection or feature point. Rather, vehicle or robot data is often collected by repeated driving of an area over/over without stopping. So, the final data set may contain many replicates of the area of interest.

This "Laps" code assists in breaking recorded path data into paths by defining specific start and end locations, for example from intersection "A" to stop sign "B". Specifically, the purpose of this code is to break data into "laps", e.g. segments of data that are defined by a clear start condition and end condition. The code finds when a given path meets the "start" condition, then meets the "end" condition, and returns every portion of the path that is inside both conditions. There are many advanced features as well including the ability to define excursion points, the number of points that must be within a condition for it to activate, and the ability to extract the portions of the paths before and after each lap, in addition to the data for each lap.

* Inputs:
  * either a "traversals" type, as explained in the Path library, or a path of XY points in N x 2 format
  * the start, end, and optional excursions can be entered as either a line segment or a point and radius.  
* Outputs
  * Separate arrays of XY points, or of indices for the lap, with one array for each lap
  * The function also can return the points that were not used for laps, e.g. the points before the first start and after the last end

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Installation

1. Make sure to run MATLAB 2020b or higher. Why? The "digitspattern" command used in the DebugTools utilities was released late 2020 and this is used heavily in the Debug routines. If debugging is shut off, then earlier MATLAB versions will likely work, and this has been tested back to 2018 releases.

2. Clone the repo

   ```sh
   git clone https://github.com/ivsg-psu/featureextraction_laneboundary_handtrace   ```

3. Run the main code in the root of the folder (script_demo_Laps.m), this will download the required utilities for this code, unzip the zip files into a Utilities folder (.\Utilities), and update the MATLAB path to include the Utility locations. This install process will only occur the first time. Note: to force the install to occur again, delete the Utilities directory and clear all global variables in MATLAB (type: "clear global *").
4. Confirm it works! Run script_demo_Laps. If the code works, the script should run without errors. This script produces numerous example images such as those in this README file.

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

<!-- STRUCTURE OF THE REPO -->
### Directories

The following are the top level directories within the repository:
<ul>
 <li>/Documents folder: Descriptions of the functionality and usage of the various MATLAB functions and scripts in the repository.</li>
 <li>/Functions folder: The majority of the code for the point and patch association functionalities are implemented in this directory. All functions as well as test scripts are provided.</li>
 <li>/Utilities folder: Dependencies that are utilized but not implemented in this repository are placed in the Utilities directory. These can be single files but are most often folders containing other cloned repositories.</li>
</ul>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

### Dependencies

* [Errata_Tutorials_DebugTools](https://github.com/ivsg-psu/Errata_Tutorials_DebugTools) - The DebugTools repo is used for the initial automated folder setup, and for input checking and general debugging calls within subfunctions. The repo can be found at: <https://github.com/ivsg-psu/Errata_Tutorials_DebugTools>

* [PathPlanning_PathTools_PathClassLibrary](https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary) - the PathClassLibrary contains tools used to find intersections of the data with particular line segments, which is used to find start/end/excursion locations in the functions. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary>

    Each should be installed in a folder called "Utilities" under the root folder, namely ./Utilities/DebugTools/ , ./Utilities/PathClassLibrary/ . If you wish to put these codes in different directories, the main call stack in script_demo_(reponame) can be easily modified with strings specifying the different location, but the user will have to make these edits directly.

    For ease of getting started, the zip files of the directories used - without the .git repo information, to keep them small - are included in this repo.

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

<!-- LANE MARKS DEFINITIONS -->
## Lane Marks

### Yellow Lane Marks

#### Solid Single Yellow Lane Mark

A single solid yellow line separates opposing traffic flows and prohibits passing.

<pre align="center">
  <img src=".\Images\solidSingleYellowLaneMarkings.png" alt="solidSingleYellowLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.1 - Solid Single Yellow Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Solid Double Yellow Lane Mark

Double solid yellow lines separate opposing traffic and prohibit passing in both directions.

<pre align="center">
  <img src=".\Images\solidDoubleYellowLaneMarkings.png" alt="solidDoubleYellowLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.2 - Solid Double Yellow Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Dashed Single Yellow Lane Mark

A single dashed yellow line separates opposing traffic and allows passing when safe.

<pre align="center">
  <img src=".\Images\dashedSingleYellowLaneMarkings.png" alt="dashedSingleYellowLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.3 - Dashed Single Yellow Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Dashed Double Yellow Lane Mark

Double dashed yellow lines separate opposing traffic and allow passing in both directions when safe.

<pre align="center">
  <img src=".\Images\dashedDoubleYellowLaneMarkings.png" alt="dashedDoubleYellowLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.4 - Dashed Double Yellow Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Solid Dashed Double Yellow Lane Mark

A solid dashed double yellow line separates opposing traffic and allows passing only for vehicles on the dashed side.

<pre align="center">
  <img src=".\Images\solidDashedDoubleYellowLaneMarkings.png" alt="solidDashedDoubleYellowLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.5 - Solid Dashed Double Yellow Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

### White Lane Marks

#### Solid Single White Lane Mark

A single solid white line separates same-direction lanes or marks the road edge and discourages lane changes.

<pre align="center">
  <img src=".\Images\solidSingleWhiteLaneMarkings.png" alt="solidSingleWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.6 - Solid Single White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Solid Double White Lane Mark

Double solid white lines separate same-direction lanes and prohibit lane changes.

<pre align="center">
  <img src=".\Images\solidDoubleWhiteLaneMarkings.png" alt="solidDoubleWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.7 - Solid Double White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Dashed Single White Lane Mark

A single dashed white line separates same-direction lanes and allows lane changes when safe.

<pre align="center">
  <img src=".\Images\dashedSingleWhiteLaneMarkings.png" alt="dashedSingleWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.8 - Dashed Single White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Short Dashed White Lane Mark

Short dashed white lines separate same-direction lanes and are commonly used in merging or transition areas to indicate permitted lane changes.

<pre align="center">
  <img src=".\Images\shortDashedWhiteLaneMarkings.png" alt="shortDashedWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.9 - Short Dashed White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Dotted Dashed White Lane Mark

Dotted white lane markings indicate a special same-direction lane boundary, often used in merge, exit, or continuation zones where crossing is permitted under defined conditions.

<pre align="center">
  <img src=".\Images\dottedDashedWhiteLaneMarkings.png" alt="dottedDashedWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.10 - Dotted Dashed White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Dashed Double White Lane Mark

Double dashed white lines separate same-direction lanes and allow lane changes in both directions when safe.

<pre align="center">
  <img src=".\Images\dashedDoubleWhiteLaneMarkings.png" alt="dashedDoubleWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.11 - Dashed Double White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Solid Dashed Double White Lane Mark

A solid dashed double white line separates same-direction lanes and allows lane changes only from the dashed side.

<pre align="center">
  <img src=".\Images\solidDashedDoubleWhiteLaneMarkings.png" alt="solidDashedDoubleWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.12 - Solid Dashed Double White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Stop Line White Lane Mark

A solid white transverse line marking the required stopping position at intersections or signalized approaches.

<pre align="center">
  <img src=".\Images\stopLineWhiteLaneMarkings.png" alt="stopLineWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.13 - Stop Line White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

#### Crosswalk White Lane Mark

White transverse or zebra markings indicating a designated pedestrian crossing area where vehicles must yield or stop.

<pre align="center">
  <img src=".\Images\crosswalkWhiteLaneMarkings.png" alt="crosswalkWhiteLaneMarkings picture" width="400" height="300">
  <figcaption>Fig.14 - Crosswalk White Lane Mark.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>


***

<!-- FUNCTION DEFINITIONS -->
## Functions

### Basic Support Functions

#### fcn_HandTrace_TEMPLATE

fcn_HandTrace_TEMPLATE gives indices of each lap meeting the zone definition.

<pre align="center">
  <img src=".\Images\fcn_Laps_plotLapsXY.png" alt="fcn_Laps_plotLapsXY picture" width="400" height="300">
  <figcaption>Fig.1 - The function fcn_Laps_plotLapsXY plots the lap outputs.</figcaption>
  <!--font size="-2">Photo by <a href="https://unsplash.com/ko/@samuelchenard?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Samuel Chenard</a> on <a href="https://unsplash.com/photos/Bdc8uzY9EPw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></font -->
</pre>

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

<!-- USAGE EXAMPLES -->
## Usage
<!-- Use this space to show useful examples of how a project can be used.
Additional screenshots, code examples and demos work well in this space. You may
also link to more resources. -->

### General Usage

Each of the functions has an associated test script, using the convention

```sh
script_test_fcn_fcnname
```

where fcnname is the function name as listed above.

As well, each of the functions includes a well-documented header that explains inputs and outputs. These are supported by MATLAB's help style so that one can type:

```sh
help fcn_fcnname
```

for any function to view function details.

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

### Examples

1. Run the main script to set up the workspace and demonstrate main outputs, including the figures included here:

   ```sh
   script_demo_Laps
   ```

    This exercises the main function of this code.

2. After running the main script to define the included directories for utility functions, one can then navigate to the Functions directory and run any of the functions or scripts there as well. All functions for this library are found in the Functions sub-folder, and each has an associated test script. Run any of the various test scripts; each can work as a stand-alone script.

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

## Major release versions

This code is still in development (alpha testing)

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

<!-- CONTACT -->
## Contact

Sean Brennan - [sbrennan@psu.edu](sbrennan@psu.edu)

Project Link: [hhttps://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps](https://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps)

<a href="#featureextraction_laneboundary_handtrace">Back to top</a>

***

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
