import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our ServerSettings table
final class ServerSettingController: ResourceRepresentable {
    /// When users call 'GET' on '/serverSettings'
    /// it should return an index of all available serverSettings
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try ServerSetting.all().makeJSON()
    }
    
    /// When consumers call 'POST' on '/serverSettings' with valid JSON
    /// construct and save the server setting
    func store(_ req: Request) throws -> ResponseRepresentable {
        let serverSetting = try req.serverSetting()
        try serverSetting.save()
        return serverSetting
    }
    
    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/serverSettings/13rd88' we should show that specific serverSetting
    func show(_ req: Request, serverSetting: ServerSetting) throws -> ResponseRepresentable {
        return serverSetting
    }
    
    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'serverSettings/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, serverSetting: ServerSetting) throws -> ResponseRepresentable {
        try serverSetting.delete()
        return Response(status: .ok)
    }
    
    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/serverSettings' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try ServerSetting.makeQuery().delete()
        return Response(status: .ok)
    }
    
    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, serverSetting: ServerSetting) throws -> ResponseRepresentable {
        // See `extension ServerSetting: Updateable`
        try serverSetting.update(for: req)
        
        // Save an return the updated server setting.
        try serverSetting.save()
        return serverSetting
    }
    
    /// When a user calls 'PUT' on a specific resource, we should replace any
    /// values that do not exist in the request with null.
    /// This is equivalent to creating a new ServerSetting with the same ID.
    func replace(_ req: Request, serverSetting: ServerSetting) throws -> ResponseRepresentable {
        // First attempt to create a new ServerSetting from the supplied JSON.
        // If any required fields are missing, this request will be denied.
        let new = try req.serverSetting()
        
        // Update the server setting with all of the properties from
        // the new serverSetting
        serverSetting.key = new.key
        serverSetting.value = new.value
        try serverSetting.save()
        
        // Return the updated server setting
        return serverSetting
    }
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<ServerSetting> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            destroy: delete
        )
    }
}

extension Request {
    /// Create a server setting from the JSON body
    /// return BadRequest error if invalid
    /// or no JSON
    func serverSetting() throws -> ServerSetting {
        guard let json = json else { throw Abort.badRequest }
        return try ServerSetting(json: json)
    }
}

/// Since ServerSettingController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension ServerSettingController: EmptyInitializable { }

