# Scrolls of Poseidon
This project aims to build a large-scale, high-quality corpus of text from oceanographic research papers, environmental reports, and conservation literature. The resulting dataset will be used to train specialized language models for tasks in marine science.

## Data Gathering
The first step is to gather the data from different archives of research and academic data all over the internet. Since, I will open-source this entire dataset once it's made, that rules out big publishers like Springer Nature, Elsevier, Wiley etc. I also looked into JSTOR, but they explicitly prohibit usage of their data for training or enhancing the outputs of any AI model.  

In all the above cases, there is an almost universal "No Distribution" clause or the trained models will be exlusively owned by the publishers who provide this paywall'ed data - neither of which agrees with the open-source nature of the data and models that will be the products of this project. Hence, I will stick to sources that have been confirmed to use permissive licenses (CC0, CC BY, CC BY-SA, Public Domain, Open Government Licences) - that grant the permissions we need to download, process, and republish the data as part of our corpus. 

For each source, we fetch the document metadata first. Then we make a request for the *full-text* only if it matches our topic of research and license compliance. I have identified the following sources and modes of access for now:
1. **OpenAlex** - provides API access to their documents without any API key although the rate is limited to 100,000 requests per day or 10 requests per second. Their complete dataset is free under the CC0 license, which allows for transparency and reuse. All we need to do is cite the `OpenAlex: A fully-open index of scholarly works, authors, venues, institutions, and concepts` paper. 
2. **CORE**	- provides API access to their documents without an API key but having one provides higher rate limits plus it's free so no qualms about registering for it. They have a rather complicated rate limits based on their self-devised concept of "tokens". Simple queries cost 1 token whereas more complex ones cost 3-5 tokens. Regular registered users get 10,000 tokens per day or 10 per minute of usage. All we need to do is cite one of their research papers. I chose this: `CORE: A Global Aggregation Service for Open Access Papers`
3. **PLOS** - provides API access to their data through Apache Solr but they give the option to bulk download their entire dataset, which comes out to around 8.5GB (compressed). This seems like a better option at first glance because it takes away the effort required to search, filter and bulk-scrape HTML pages, although it does add the effort to sift through the bulk data and find the relevant documents. I'm sure there's metadata associated with each file that can be used to classify them into relevant categories for usage in this project.
4. **arXiv** - provides API access to their data without any API key. Rate Limits are 1 request per 3 seconds. There are PyPi packages that serve as wrappers over the arXiv base APIs and take away some of the overhead of using them. I'll use them in this project. Similarly for other sources that have such clients available.
5. **PubMed Central OA Subset** - provides API access via NCBI Entrez Programming Utilities with the exact syntax for `ESearch`, `ESummary`, and `EFetch`, which is the precise workflow we need. It does need an API key for effective rate limits of 10 requests per second.
6. **IPCC Reports** - no API access here. The files need to be manually downloaded/programmatically scraped but the volume is very less here so either is fine.
7. **NASA** - provides API access to all it's research data at 1000 requests per hour on a rolling basis. It has very high quality data on observing Earth's oceans. I'll pull the relevant literature only.
8. **NOAA Repository** - no API access here. The reports all need to be scraped in a *polite* manner. It has very high quality reports on basically everything related to oceans and marine life.
9. **UNESCO AquaDocs** - provides API access via the OAI-PMH Protocol. We need to extract the metadata and then individually download papers of interest. There is no API key required and it seems to be designed for a process called `harvesting` where we sequentially extract batches of records one after the other. We will be *polite* here too, making 1 request at a time with 1-2 second gap between each request. 
10. 

Other sources that I will use but I will not include in the mined open-source corpus:
1. **bioRxiv** - provides a `requester-pays` S3 bucket with access to all articles. The problem is, they explicitly mention the following: The TDM repository is not intended as a source for further redistribution of articles posted on bioRxiv, or their derivatives, nor does it grant others permission to re-host content posted on bioRxiv.  For most articles submitted to bioRxiv, authors retain copyright and reuse rights.  If you build indexing services or tools based on the full text of articles, you must therefore link back to the text hosted at bioRxiv rather than re-host content.
    This means, while I can use the data to train my model, I cannot re-host (even as part of my corpus) it on any platform that leads away from bioRxiv. So I will create Corpus Manifesto which will lead to the original articles used. And I will do this for all the platforms from which I get the data. The `metadata.csv` file is the heart of this project. It serves as a complete and transparent manifest of every document used to build the "Scrolls of Poseidon" corpus and train the Ocean-BERT model. This file provides full attribution to the original authors and platforms and ensures our project is reproducible and ethically sound.  
The manifest contains the following columns:  
`doc_id`: A unique identifier we assign to each document for internal tracking.  
`source_platform`: The original platform where the document was sourced (e.g., "OpenAlex", "bioRxiv", "PLOS", "NOAA").  
`doi`: The Digital Object Identifier (DOI) of the work, if available.  
`source_url`: A direct, persistent link to the original document's landing page.  
`title`: The full title of the work.  
`authors`: A list of the work's authors.  
`journal`: The name of the journal or publishing entity.  
`publication_date`: The date the work was published.  
`license`: The specific license under which the work is shared (e.g., "CC BY 4.0", "Public Domain").  
`corpus_availability`: A status field indicating whether the full text is included in our public corpus, in accordance with platform policies.  
`included`: The full text is provided in our downloadable corpus files. This applies to sources like PLOS or CC-BY content from aggregators.  
`link_only`: The full text is not redistributed by us due to platform policy. Use the source_url to access the document from the original host. This applies to `sources like bioRxiv.

