# Constraint Modeling With Schemas
Exploration of schema-driven constraint modeling in the context of integrating and EDC system with an SDR implementation.

## Rationale
Currently, the standard for modeling study defnitions is the metadata part of ODM XML.

ODM's own metadata constraints are available as an XSD schema that described an ontology of metadata entities (FormsDefs, StudyEventDefs, ItemDefs and so on) and their relationships. 

Any concrete ODM Metadata file ("Study Definition") may be a valid "implementation" of that standard, but is itself not another Schema, but an XML file. It constitutes a further narrowing of the constraints given by ODM. E.g. where the ODM standard expects a "SubjectData" Element to have a "StudyEventData" child and a "FormData" child below that, a study definition explicates, what exactly the allowed children are and in which order they appear. The original purpose of these files was to be submitted as metadata alongside the actual data. In the context of ongoing efforts to create sophisticated data flows built on top of distributed systems, it may seem natural to consider an ODM study definition to be something like a shared contract between an SDR and an EDC system. So far, our experience is that this attempt is riddled with complications that mostly stem from the idea of using a study definition XML files as a shared contract between two computer systems. It seems dangerous at this point to use the ODM standard in a way that it was never intended for.

## Using ODM XML as a shared contract

### Insufficient expressive power

At XClinical, we make heavy use of our own vendor extensions to amend the shortcomings of ODM, regarding relationships of entities conditional validity. To name just one examples:  ConditionDefs are insufficient to model complex enable/disable behavior of elements.

### System idiosyncrasies and extension versus composition

Each EDC systems has different features to e.g. use radio buttons instead of select lists, display content horizontally instead of vertically and so on. We use our extensions to configure these idiosyncrasies. There are only two means of doing that: Change the file in place or reference it from a new metadata version using the "Include" element. The former implies the risk of accidentally changing the original study definition and makes it impossible to deal with changes during the study. E.g., if we receive an MDV 1.0 from an upstream SDR, add our extension to it, how would we reconcile our merged version of 1.0 with the changes again? We could use ODM's "Include" element at that point, but this still doesn't properly solve the problem, since there are plenty of extensions that redefine ("overwrite") existing elements, so that the first problem of controlling changes comes up again.

### No guarantees on the data returned

The major drawback of a Study Definition in this context is that is cannot be used as a means to validate the data that was produced by the system. There is no objective way to tell that the constraints are met. Both parties simply have to trust the system and fix potential issues in a costly manner whenever problems arise. Alternatively, they can create their own means of validation. Both routes seem unnecessarily expensive and time consuming.

### Shared Model Problem
The study definition thus serves as a monolithic shared model that any involved party can just add to. As a consequence, each involved system needs to implement increasingly sophisticated means to reflect the model's complexity instead of limiting itself to its own responsibilities. In a distributed system, any consumer of data should have a way of expressing its on constraints on a producer's data via a shared contract (see e.g. "Consumer-Driven Contract Testing: https://pactflow.io/what-is-consumer-driven-contract-testing/).

## Using Schemas as a shared contract

The standard way of establishing a shared contract regarding aggregate-level data between systems in the world of web services is a schema. If system A accepts data from system B, then it usually exposes a description of what valid data looks like. A contract can be considered shared, if both sides can verify that the data adheres to it. A Typical example is JSON Schema as used by OpenAPI. Since we're still dealing with XML data being exported, in our case XML Schema (XSD) seems like the the most natural solution. Using XSD would have the following advantages:

1. It allows to utilize the expressive power of XML Schema.
2. It can be used to validate any kind of data, not just ECRF data.
3. Due to its composable nature, it would allow for a modular way to combine and layer constraints, where e.g. structural concerns are clearly separated from other concerns. In ODM the only way of modularizing different constraints is MDV mechanism, which is clearly not intended for this and due to its missing type system doesn't allow for any kind of polymorphism (e.g. an ItemDef can either be overwritten as a whole or not).
4. It allows anybody to utilize the rich existing tooling for XML Schema to validate data, generate test data and so on.
5. It drastically lowers the requirements for EDC systems to integrate with an SDR. Instead of supporting an import of the model and having to ensure consistency all the way to the export, EDC systems only need to ensure validity of the data exported. In other words, it is up to the vendor how they satisfy the constraints.
6. It allows us to build system that are able to automatically validate and digest that data for further processing.

## Simple example of the expressive power of XSD
This example files "pregnant.xml" and "pregant.xsd" on https://github.com/mroseneck/connectathon-constraint-modelling shows a typical real-world use case in a trial. An inclusion item group has three items, that are to be conditionally and successively enabled, i.e.:

1. If the "gender" item has the value "m", then no other items must be present.
2. If the "gender" item has the value "f", then the item "pregnant" must be present and have a value.
3. If the "pregnant" item has the value "n", then the item "month" must not be present.
4. If the "pregnant" item has the value "y", then the item "month" must be present and have a value between 0 and 11.

This entire logic is nicely encapsulated in just two lines of simple XPATH in lines 22 and 23 that do not touch the other constraints at all.

Besides that, the xsd showcases some of the typical features of ODM files, e.g.:

1. structural constraints (which items are valid in the context of that item group)
2. range checks (on "month")
3. controlled terminology (items "gender" and "pregnant")
4. conditional validity based on values (see above)
5. internationalized annotations for human readers (line 11)
6. machine-readable annotations (lines 13 14)

## Convertibility
Some prototyping showed very promising results regarding the possibility to create an XSD schema from any concrete ODM XML file using a single XSLT. If proper conventions are followed, even the reverse operation is possible. Both are possible serialization formats of an underlying SDR. The interesting question is: how do we continue from here? Do we add more extensions to ODM in order to get more guarantees for system integration, or do we switch to a proper shared contract now? At some point, these decisions will define the systems we are building on top of them.

## Running the example
An XSD 1.1 processor is required to appy this schema to the data. E.g. Saxon or Xerces.

## Conclusions
While it may still be too early to conclude that schemas are the way to go here, it certainly seems like a very promising direction for further research. The idea is nothing new, it would merely an alignment with established standards for cross-service communication in the world of web services.
