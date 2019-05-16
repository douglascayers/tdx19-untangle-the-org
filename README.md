# TDX19 Untangle the Org

Sample code that accompanies the [Untangle Your Org With Salesforce Developer Tools](https://success.salesforce.com/myagenda?eventId=a1Q3A000026slov#/session/a2q3A000002BGcEQAW)
session at [TrailheaDX '19](https://www.salesforce.com/trailheadx/), presented by [Shane McLaughlin](https://twitter.com/MShaneMc) and [Doug Ayers](https://twitter.com/DouglasCAyers).

**Tangled** in this context means code and/or metadata that has dependencies in such a way that
make it difficult to isolate subsets of that code and/or metadata into logical packages that can
be developed and released independently of each other.

This repository includes examples of how to modularize code and metadata into packages
using Change Data Capture platform events or Dependency Injection with the [force-di](https://github.com/afawcett/force-di) library.

## demo-tangled-app

Example of an org where business logic and processes from multiple
apps are tangled in a shared code base.

## demo-untangled-cdc-pkg1 and demo-untangled-cdc-pkg2

Example of modularizing code and/or metadata into separate packages
by moving business logic out of a shared trigger on the Account object
and into independent triggers that listen for Change Data Capture events.

### When to Use

For business logic that truly is independent of each other but just happen to share
a common object (e.g. Account, Contact, Task, etc), or for business logic that can be
performed asynchronously from the main transaction.

## demo-untangled-di-pkg1 and demo-untangled-di-pkg2

Example of modularizing code and/or metadata into separate packages
by shifting compile-time dependencies to runtime dependencies using
Dependency Injection with the [force-di](https://github.com/afawcett/force-di) library.
