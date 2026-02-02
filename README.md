
Dr Bill Pascoe
Naarm/Melbourne, Australia
CC BY-NC 4.0, 2026

TOTPipe: Tidy OCR Text Pipeline has processes to work from 

scanned image/pdf -> OCR -> Assisted human checks -> AI clean up -> Assisted human checks -> (re)Publication Formats -> downstream processes such as NER

These scripts are working but are still active code adapting to the needs of an active project, so could do with some refactoring and refinement.
Some aspects are customised to that project, but the code could easily be modified and adapted to other projects.

It includes:
- one set of command line processes (optionally in a .bat file)
- several Jupyter Notebooks (Python).

The aim is to have a set of scripts performing various aspects of a scan to clean (as possible) text output.
This includes tools for making the OCR as clean as possible *automatically*, and tools to assist with *manual checking* and correction that is inevitably required for a quality result.
All steps are optional depending on what you have and what you want.

ScansToOCR_Pipeline.txt and/or pdf2ocrtxt.bat
This converts PDFs or images of scanned pages of texts into OCR text. Read ScansToOCR_Pipeline.txt to install dependencies, and run each step in the terminal/command prompt. You can also use the pdf2ocrtxt.bat file after installing the dependencies to do the same thing, by placing it in the folder containing the pdf or images you want to convert to text, and running it, passing it the file name of the pdf or images. This is likely to be used a single large text in which case you might want to skip to OCRCleaner. Many of the processes are for handling many articles. 

The following are Jupyter Notebooks (python) for processing and cleaning OCR text).

Most of them have been designed around a project where multiple short texts (historical news articles from Trove) are collected in a single text file with each text seperated by a line of hashtags, following by a citation (in Trove APA format) followed by the body of the text. An example is at the bottom of this README.
They are roughly in the order you might want to run them. But you can run them in a different order if that suits.

DateSorter.jpynb
This simply reads in the text file, splits up each article, gets the publication date and outputs them in date order. If you are using a different citation format you may need to change the date extraction method.

VeryBadOCRBlocks.jpynb
Later processes do good job of cleaning up OCR glitches, if they are minimal and the sense is clear. However, in some cases OCR is so bad, such as were text has been torn out, covered in a stain, a picture is transformed to 'text' etc. In these cases an AI process, for example, might none the less give you completely wrong text that sounds coherent but is completely made up. This process ranks the extent of OCR glitches in blocks of text so that you can ignore moderate glitches which downstream processes can be trusted with, and focus human intervention on areas where glitches are extremely bad. You can delete, manually correct or just keep an eye on these, etc.

ReprintChecker.jpynb
Sometimes newspapers simply reprinted an article from another newspaper. If you are collecting a lot of articles and pasting all these reprints into your file. In some cases you might want every publication, even of the same article. 
Or sometimes, you might accidentally paste the same article in your collection file more than once.
This ranks repetitions of blocks of text. Text that is exactly the same has a high score, for finding duplicates and reprints. 
You might also find some articles repeat just some sections of text, or are similar. These recieve lower scores.

TopicFilter.jpynb
You might be collecting articles on a certain topic. Some news articles are a digest of a lot of reporting on different topics, or the imperfect OCR process might included many articles in one. If, for example, you want news on a specific topic, you might want to remove long reporting on other topics that would be noise. Eg: if I were looking for articles on the Eureka Stockage, I might want to remove reporting on horse sales, wars in another country, a baking competition, etc. This script enables you to generate a sort of digital 'signature' of your topic, based on samples of it. Using that 'signature' you can run the process to rank blocks of text that match that 'signature' least - ie: articles that are on unrelated topics. The threshold for 'related' or 'unrelated' depends on your sample texts and your judgement of the results and similarity rankings. If you are dealing with large volumes of text, this can help quickly weed out irrelevant material.

OCRCleaner.jpynb
This is the main script for cleaning text. Unfortunately, it requires a subscription to OpenAI to obtain an API key. However, very large amounts of text (hundreds of thousands of words) can be processed for just a few dollars, on top of a fairly small monthly subscription fee. While the approach is always to use free open source wherever possible, the quality of OpenAI OCR cleaning far exceeds any other option making it worth while. Older, free methods barely make it worthwhile, still requiring extensive manual correction. OpenAI approaches human accuracy. The main cautions are: 
1) it is only reliable with carefully constructed prompts to minimise 'hallucination', inventing information, and making unwanted changes, especially in historic texts.
2) incorrect changes are difficult to spot because AI is so good at making coherant language.
None the less so long as these are born in mind, caveats accompany the results, and direct quotes, and details such as numbers, are checked against the original, the results are a vast improvement on uncorrected, glitchy OCR images, making this worthwhile.
This is designed with two modes for processing:
1. a large single text file, such as a book (it will break it into chunks of text to sent to the OpenAI API and reassemble the cleaned text)
2. collections of shorter articles in a single text file (example below)

FormatForPub.jpynb
This reads in a text file, after you have made automated and manual corrections, and outputs it as HTML PDF and ePub, ready for publication, including metadata you specify.

NERPeople
Having a clean text you may want to do some analysis of it. Eg: to identify people and places in the text you can use:
'FindPeopleInTexts' https://github.com/BillPascoe/FindPeopleInTexts/tree/main
or to geolocate and map places, you could use TLCMap TextMap:
https://tlcmap.org/



EXAMPLE .TXT FILE OF NEWS ARTICLES

########

THE BALLARAT RIOTS. (1854, December 8). The Courier (Hobart, Tas. : 1840 - 1859), p. 2. Retrieved September 28, 2025, from http://nla.gov.au/nla.news-article2240571

We resume our precis of the important intelligence received from Melbourne by the London steamship

(yesterday), giving full particulars of the collision between the military and the Ballarat rioters.

... etc ...

########

SUPREME COURT. (1855, March 27). The Age (Melbourne, Vic. : 1854 - 1954), p. 5. Retrieved September 28, 2025, from http://nla.gov.au/nla.news-article154852643

SUPREME COURT.

Monday, March 26, 1855. Old Court. The State Trial concluded. (Before His Honor Mr. Justice Barry.

... etc ...
