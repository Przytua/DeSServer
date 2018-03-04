import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our RequestLogs table
final class RequestLogController: ResourceRepresentable {
    /// When users call 'GET' on '/requestLogs'
    /// it should return an index of all available requestLogs
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try RequestLog.all().makeJSON()
    }

    /// When consumers call 'POST' on '/requestLogs' with valid JSON
    /// construct and save the request log
    func store(_ req: Request) throws -> ResponseRepresentable {
        let requestLog = try req.requestLog()
        try requestLog.save()
        return requestLog
    }

    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/requestLogs/13rd88' we should show that specific requestLog
    func show(_ req: Request, requestLog: RequestLog) throws -> ResponseRepresentable {
        return requestLog
    }

    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'requestLogs/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, requestLog: RequestLog) throws -> ResponseRepresentable {
        try requestLog.delete()
        return Response(status: .ok)
    }

    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/requestLogs' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try RequestLog.makeQuery().delete()
        return Response(status: .ok)
    }

    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, requestLog: RequestLog) throws -> ResponseRepresentable {
        // See `extension RequestLog: Updateable`
        try requestLog.update(for: req)

        // Save an return the updated request log.
        try requestLog.save()
        return requestLog
    }

    /// When a user calls 'PUT' on a specific resource, we should replace any
    /// values that do not exist in the request with null.
    /// This is equivalent to creating a new RequestLog with the same ID.
    func replace(_ req: Request, requestLog: RequestLog) throws -> ResponseRepresentable {
        // First attempt to create a new RequestLog from the supplied JSON.
        // If any required fields are missing, this request will be denied.
        let new = try req.requestLog()

        // Update the request log with all of the properties from
        // the new requestLog
        requestLog.endpoint = new.endpoint
        requestLog.requestHeaders = new.requestHeaders
        requestLog.requestBody = new.requestBody
        requestLog.responseHeaders = new.responseHeaders
        requestLog.responseBody = new.responseBody
        try requestLog.save()

        // Return the updated request log
        return requestLog
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<RequestLog> {
        return Resource(
            index: index,
            show: show
        )
    }
}

extension Request {
    /// Create a request log from the JSON body
    /// return BadRequest error if invalid 
    /// or no JSON
    func requestLog() throws -> RequestLog {
        guard let json = json else { throw Abort.badRequest }
        return try RequestLog(json: json)
    }
}

/// Since RequestLogController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension RequestLogController: EmptyInitializable { }
