/*
 * Copyright (C) 2005 National Association of REALTORS(R)
 *
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished
 * to do so, provided that the above copyright notice(s) and this
 * permission notice appear in all copies of the Software and that
 * both the above copyright notice(s) and this permission notice
 * appear in supporting documentation.
 */
#include <iostream>
#include "librets/FieldCriterion.h"

using namespace librets;
using std::string;
using std::ostream;

FieldCriterion::FieldCriterion(string field, DmqlCriterionPtr value)
    : mField(field), mValue(value)
{
}

ostream & FieldCriterion::Print(ostream & outputStream) const
{
    return outputStream << "(<" << mField << "> " << OperationName() << " <"
                        << mValue << ">)";
}

bool FieldCriterion::Equals(const RetsObject * object) const
{
    const FieldCriterion * rhs =
        dynamic_cast<const FieldCriterion *>(object);
    if (rhs == 0)
    {
        return false;
    }

    bool equals = true;
    equals &= (mField == rhs->mField);
    equals &= (OperationName() == rhs->OperationName());
    equals &= (*mValue == *rhs->mValue);
    return equals;
}
